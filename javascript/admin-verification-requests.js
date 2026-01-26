document.addEventListener('DOMContentLoaded', function () {
    loadVerificationRequests();
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

async function loadVerificationRequests() {
    const container = document.querySelector('.requests-list');

    if (!container) {
        console.error('Requests list container not found');
        return;
    }

    // Show loading state
    container.innerHTML = `
        <div class="loading">
            <i class="fas fa-spinner fa-spin"></i>
            <p>Loading verification requests...</p>
        </div>
    `;

    try {
        const response = await fetch('api/api-admin-verification.php', {
            credentials: 'include'
        });
        const data = await response.json();

        console.log('API Response:', data); // Debug log

        if (!data.success) {
            // Show error message if API returns error
            container.innerHTML = `
                <div class="empty-state">
                    <i class="fas fa-exclamation-triangle"></i>
                    <h3>Error</h3>
                    <p>${data.error || 'Failed to load verification requests'}</p>
                </div>
            `;
            return;
        }

        if (data.requests && data.requests.length > 0) {
            container.innerHTML = '';
            data.requests.forEach(req => {
                container.innerHTML += createVerificationCard(req);
            });
            attachEventListeners();
        } else {
            container.innerHTML = `
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <h3>No verification requests found</h3>
                    <p>There are currently no verification requests to review.</p>
                </div>
            `;
        }
    } catch (error) {
        console.error('Error loading verification requests:', error);
        container.innerHTML = `
            <div class="empty-state">
                <i class="fas fa-exclamation-triangle"></i>
                <h3>Error loading data</h3>
                <p>Please try refreshing the page. Error: ${error.message}</p>
            </div>
        `;
    }
}

function createVerificationCard(req) {
    const initials = req.full_name ? req.full_name.split(' ').map(n => n[0]).join('').substring(0, 2).toUpperCase() : 'NA';
    const dateUploaded = new Date(req.uploaded_at).toLocaleDateString('en-US', {
        month: 'short',
        day: 'numeric',
        year: 'numeric'
    });

    return `
        <div class="request-item" data-search="${req.full_name?.toLowerCase()} ${req.email?.toLowerCase()} ${req.student_id?.toLowerCase()}">
            <div class="request-id">#${req.user_id}</div>
            <div class="user-avatar">${initials}</div>
            <div class="user-info">
                <div class="user-name">${req.full_name || 'Unknown User'}</div>
                <div class="user-email">${req.email || 'No email'}</div>
            </div>
            <div class="info-badge">${req.student_id || 'N/A'}</div>
            <div class="info-badge">${req.university || 'N/A'}</div>
            <div class="info-badge">${dateUploaded}</div>
            
            <div class="request-actions">
                <button class="btn btn-view" onclick="viewDocument('${req.file_path}')">
                    View Document
                </button>
                
                ${req.verification_status === 'pending' ? `
                    <button class="btn btn-approve" data-id="${req.user_id}" data-action="approve">
                        Approve
                    </button>
                    <button class="btn btn-decline" data-id="${req.user_id}" data-action="reject">
                        Decline
                    </button>
                ` : `
                    <span class="status-badge status-${req.verification_status}">
                        ${req.verification_status.toUpperCase()}
                    </span>
                `}
            </div>
        </div>
    `;
}

function attachEventListeners() {
    // Approve buttons
    document.querySelectorAll('.btn-approve').forEach(btn => {
        btn.addEventListener('click', function () {
            const userId = this.getAttribute('data-id');
            handleApproval(userId, 'approve');
        });
    });

    // Decline buttons
    document.querySelectorAll('.btn-decline').forEach(btn => {
        btn.addEventListener('click', function () {
            const userId = this.getAttribute('data-id');
            handleApproval(userId, 'reject');
        });
    });
}

async function handleApproval(userId, action) {
    // Disable buttons during processing
    const buttons = document.querySelectorAll(`[data-id="${userId}"]`);
    buttons.forEach(btn => {
        btn.disabled = true;
        btn.style.opacity = '0.5';
    });

    try {
        const response = await fetch('api/api-admin-verification.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            credentials: 'include',
            body: JSON.stringify({
                action: action,
                user_id: userId
            })
        });

        const data = await response.json();

        if (data.success) {
            showNotification(
                action === 'approve'
                    ? 'Verification approved successfully!'
                    : 'Verification declined',
                'success'
            );
            // Reload the list
            loadVerificationRequests();
        } else {
            showNotification('Error: ' + data.error, 'error');
            // Re-enable buttons
            buttons.forEach(btn => {
                btn.disabled = false;
                btn.style.opacity = '1';
            });
        }
    } catch (error) {
        console.error('Error:', error);
        showNotification('Failed to process request', 'error');
        // Re-enable buttons
        buttons.forEach(btn => {
            btn.disabled = false;
            btn.style.opacity = '1';
        });
    }
}

function viewDocument(filePath) {
    const modal = document.createElement('div');
    modal.className = 'document-modal';
    modal.innerHTML = `
        <div class="modal-overlay" onclick="this.parentElement.remove()"></div>
        <div class="modal-content">
            <button class="close-modal" onclick="this.closest('.document-modal').remove()">
                <i class="fas fa-times"></i>
            </button>
            <img src="${filePath}" alt="Verification Document">
        </div>
    `;
    document.body.appendChild(modal);
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
