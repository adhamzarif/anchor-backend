
// View Loan Offers Modal
async function viewLoanOffers(loanId) {
    try {
        const response = await fetch(`api/api-get-loan-offers.php?loan_id=${loanId}`, {
            credentials: 'include'
        });
        const data = await response.json();

        if (!data.success) {
            showToast('Error', data.error || 'Failed to load offers', 'error');
            return;
        }

        if (!data.offers || data.offers.length === 0) {
            showToast('No Offers', 'No pending offers for this loan', 'info');
            return;
        }

        showOffersModal(data.offers, loanId, data.loan);
    } catch (error) {
        console.error('Error:', error);
        showToast('Error', 'Failed to load offers', 'error');
    }
}

function showOffersModal(offers, loanId, loan) {
    const modal = document.createElement('div');
    modal.className = 'offers-modal-overlay';
    modal.innerHTML = `
        <div class="offers-modal">
            <div class="offers-modal-header">
                <h2><i class="fas fa-hand-holding-usd"></i> Loan Offers (${offers.length})</h2>
                <p>Loan Amount: ৳${parseFloat(loan.amount).toLocaleString()}</p>
                <button class="offers-modal-close" onclick="this.closest('.offers-modal-overlay').remove()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="offers-modal-body">
                ${offers.map(offer => `
                    <div class="offer-card">
                        <div class="offer-header">
                            <div class="offer-lender-info">
                                <i class="fas fa-user-circle" style="font-size: 2.5rem; color: #70C1BF;"></i>
                                <div>
                                    <h3>${offer.lender_name || offer.lender_username}
                                        ${offer.verification_status === 'verified' ? '<i class="fas fa-check-circle verified-badge" title="Verified User"></i>' : ''}
                                    </h3>
                                    <p class="offer-rating">
                                        ${offer.lender_rating > 0 ? `★ ${parseFloat(offer.lender_rating).toFixed(1)} (${offer.rating_count} reviews)` : 'No ratings yet'}
                                    </p>
                                </div>
                            </div>
                            <div class="offer-date">${new Date(offer.created_at).toLocaleDateString()}</div>
                        </div>
                        <div class="offer-details">
                            <div class="offer-detail-row">
                                <span class="offer-label"><i class="fas fa-money-bill-wave"></i> Offer Amount:</span>
                                <span class="offer-value">৳${parseFloat(offer.amount).toLocaleString()}</span>
                            </div>
                            <div class="offer-detail-row">
                                <span class="offer-label"><i class="fas fa-percentage"></i> Interest Rate:</span>
                                <span class="offer-value">${offer.interest_rate > 0 ? offer.interest_rate + '%' : 'Interest-Free'}</span>
                            </div>
                            ${offer.terms ? `
                            <div class="offer-terms">
                                <span class="offer-label"><i class="fas fa-file-contract"></i> Terms:</span>
                                <p>${offer.terms}</p>
                            </div>
                            ` : ''}
                        </div>
                        <button class="btn-accept-offer" onclick="acceptOffer(${offer.offer_id}, ${loanId})">
                            <i class="fas fa-check-circle"></i> Accept This Offer
                        </button>
                    </div>
                `).join('')}
            </div>
        </div>
    `;

    document.body.appendChild(modal);

    // Close on backdrop click
    modal.addEventListener('click', (e) => {
        if (e.target === modal) {
            modal.remove();
        }
    });
}

async function acceptOffer(offerId, loanId) {
    if (!confirm('Are you sure you want to accept this offer? All other offers will be automatically rejected.')) {
        return;
    }

    try {
        const response = await fetch('api/api-accept-offer.php', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            credentials: 'include',
            body: JSON.stringify({ offer_id: offerId })
        });

        const data = await response.json();

        if (data.success) {
            showToast('Success!', 'Offer accepted successfully. The lender has been notified.', 'success');
            // Close modal
            document.querySelector('.offers-modal-overlay')?.remove();
            // Reload profile to update offer count
            setTimeout(() => loadUserProfile(), 1500);
        } else {
            showToast('Error', data.error || 'Failed to accept offer', 'error');
        }
    } catch (error) {
        console.error('Error:', error);
        showToast('Error', 'Failed to accept offer', 'error');
    }
}
