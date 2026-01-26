document.addEventListener('DOMContentLoaded', function () {
    loadUsers();
    setupSearchFilter();
});

function setupSearchFilter() {
    const searchInput = document.getElementById('searchInput');
    const clearBtn = document.getElementById('clearSearch');

    if (searchInput) {
        searchInput.addEventListener('input', function (e) {
            const searchTerm = e.target.value.toLowerCase();
            clearBtn.style.display = searchTerm ? 'block' : 'none';

            const items = document.querySelectorAll('.request-item');
            items.forEach(item => {
                const searchData = item.getAttribute('data-search') || '';
                if (searchData.includes(searchTerm)) {
                    item.style.display = 'flex';
                } else {
                    item.style.display = 'none';
                }
            });
        });
    }

    if (clearBtn) {
        clearBtn.addEventListener('click', function () {
            searchInput.value = '';
            clearBtn.style.display = 'none';
            document.querySelectorAll('.request-item').forEach(item => {
                item.style.display = 'flex';
            });
        });
    }
}

async function loadUsers() {
    const container = document.querySelector('.requests-list');

    if (!container) {
        console.error('Requests list container not found');
        return;
    }

    // Show loading state
    container.innerHTML = `
        <div class="loading">
            <i class="fas fa-spinner fa-spin"></i>
            <p>Loading users...</p>
        </div>
    `;

    try {
        const response = await fetch('api/api-admin-users.php', {
            credentials: 'include'
        });
        const data = await response.json();

        console.log('API Response:', data);

        if (!data.success) {
            container.innerHTML = `
                <div class="empty-state">
                    <i class="fas fa-exclamation-triangle"></i>
                    <h3>Error</h3>
                    <p>${data.error || 'Failed to load users'}</p>
                </div>
            `;
            return;
        }

        if (data.users && data.users.length > 0) {
            container.innerHTML = '';
            data.users.forEach(user => {
                container.innerHTML += createUserCard(user);
            });
            attachEventListeners();
        } else {
            container.innerHTML = `
                <div class="empty-state">
                    <i class="fas fa-users"></i>
                    <h3>No users found</h3>
                    <p>There are currently no registered users in the system.</p>
                </div>
            `;
        }
    } catch (error) {
        console.error('Error loading users:', error);
        container.innerHTML = `
            <div class="empty-state">
                <i class="fas fa-exclamation-triangle"></i>
                <h3>Error loading data</h3>
                <p>Please try refreshing the page. Error: ${error.message}</p>
            </div>
        `;
    }
}

function createUserCard(user) {
    const initials = user.full_name ? user.full_name.split(' ').map(n => n[0]).join('').substring(0, 2).toUpperCase() : 'NA';
    const joinDate = new Date(user.created_at).toLocaleDateString('en-US', {
        month: 'short',
        day: 'numeric',
        year: 'numeric'
    });

    const verifiedBadge = user.verification_status === 'verified'
        ? '<i class="fas fa-check-circle" style="color: #00bfa5; margin-left: 5px;" title="Verified"></i>'
        : '';

    return `
        <div class="request-item" data-search="${user.full_name?.toLowerCase()} ${user.email?.toLowerCase()} ${user.student_id?.toLowerCase()} ${user.username?.toLowerCase()}">
            <div class="request-id">#${user.user_id}</div>
            <div class="user-avatar">${initials}</div>
            <div class="user-info">
                <div class="user-name">${user.full_name || 'Unknown User'}${verifiedBadge}</div>
                <div class="user-email">${user.email || 'No email'}</div>
            </div>
            <div class="info-badge">${user.student_id || 'N/A'}</div>
            <div class="info-badge">${user.university || 'N/A'}</div>
            <div class="info-badge">
                <i class="fas fa-hand-holding-usd"></i> ${user.loan_count || 0} Loans
            </div>
            <div class="info-badge">
                <i class="fas fa-hands-helping"></i> ${user.funding_count || 0} Fundraisers
            </div>
            <div class="info-badge">${joinDate}</div>
            
            <div class="request-actions">
                <button class="btn btn-delete-user" data-id="${user.user_id}" data-name="${user.full_name}" data-email="${user.email}" data-loans="${user.loan_count}" data-funding="${user.funding_count}">
                    <i class="fas fa-trash-alt"></i> Delete Account
                </button>
            </div>
        </div>
    `;
}

function attachEventListeners() {
    document.querySelectorAll('.btn-delete-user').forEach(btn => {
        btn.addEventListener('click', function () {
            const userId = this.getAttribute('data-id');
            const userName = this.getAttribute('data-name');
            const userEmail = this.getAttribute('data-email');
            const loanCount = this.getAttribute('data-loans');
            const fundingCount = this.getAttribute('data-funding');

            showDeleteModal(userId, userName, userEmail, loanCount, fundingCount);
        });
    });
}

function showDeleteModal(userId, userName, userEmail, loanCount, fundingCount) {
    const modal = document.getElementById('deleteModal');
    const userInfoModal = modal.querySelector('.user-info-modal');
    const confirmBtn = document.getElementById('confirmDeleteBtn');

    userInfoModal.innerHTML = `
        <strong>User:</strong> ${userName} (${userEmail})<br>
        <strong>Loans:</strong> ${loanCount} | <strong>Fundraisers:</strong> ${fundingCount}
    `;

    modal.style.display = 'flex';

    // Remove old event listener and add new one
    const newConfirmBtn = confirmBtn.cloneNode(true);
    confirmBtn.parentNode.replaceChild(newConfirmBtn, confirmBtn);

    newConfirmBtn.addEventListener('click', () => deleteUser(userId));
}

function closeDeleteModal() {
    const modal = document.getElementById('deleteModal');
    modal.style.display = 'none';
}

async function deleteUser(userId) {
    const confirmBtn = document.getElementById('confirmDeleteBtn');

    confirmBtn.disabled = true;
    confirmBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Deleting...';

    try {
        const response = await fetch('api/api-admin-users.php', {
            method: 'DELETE',
            headers: { 'Content-Type': 'application/json' },
            credentials: 'include',
            body: JSON.stringify({ user_id: userId })
        });

        const data = await response.json();

        if (data.success) {
            showNotification('User account deleted successfully', 'success');
            closeDeleteModal();
            loadUsers(); // Reload the list
        } else {
            showNotification('Error: ' + data.error, 'error');
            confirmBtn.disabled = false;
            confirmBtn.innerHTML = '<i class="fas fa-trash-alt"></i> Delete User Permanently';
        }
    } catch (error) {
        console.error('Error:', error);
        showNotification('Failed to delete user account', 'error');
        confirmBtn.disabled = false;
        confirmBtn.innerHTML = '<i class="fas fa-trash-alt"></i> Delete User Permanently';
    }
}

function showNotification(message, type = 'success') {
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.innerHTML = `
        <i class="fas fa-${type === 'success' ? 'check-circle' : 'exclamation-circle'}"></i>
        <span>${message}</span>
    `;
    document.body.appendChild(notification);

    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease-out';
        setTimeout(() => notification.remove(), 300);
    }, 3000);
}

// Close modal when clicking overlay
document.addEventListener('click', function (e) {
    if (e.target.classList.contains('modal-overlay')) {
        closeDeleteModal();
    }
});
