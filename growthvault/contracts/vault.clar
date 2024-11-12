;; GrowthVault: Secure Legacy Vault with Inactivity-Based Asset Transfer

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-unauthorized (err u102))
(define-constant err-already-initialized (err u103))
(define-constant err-inactive (err u104))
(define-constant err-insufficient-signatures (err u105))
(define-constant err-asset-limit-reached (err u106))

;; Data Maps
(define-map vaults
  { owner: principal }
  {
    assets: (list 100 principal),
    beneficiaries: (list 5 principal),
    inactivity-period: uint,
    last-activity: uint,
    required-signatures: uint
  }
)

(define-map authorized-signers
  { vault-owner: principal, signer: principal }
  { authorized: bool }
)

(define-map pending-transfers
  { vault-owner: principal }
  {
    initiated-at: uint,
    signatures: (list 5 principal)
  }
)

;; Private Functions
(define-private (is-owner (user principal))
  (is-eq tx-sender user)
)

(define-private (current-time)
  (unwrap-panic (get-block-info? time u0))
)

(define-private (is-inactive (vault-data {
                               assets: (list 100 principal),
                               beneficiaries: (list 5 principal),
                               inactivity-period: uint,
                               last-activity: uint,
                               required-signatures: uint
                             }))
  (> (- (current-time) (get last-activity vault-data)) (get inactivity-period vault-data))
)

;; Public Functions
(define-public (initialize-vault (beneficiaries (list 5 principal)) (inactivity-period uint) (required-signatures uint))
  (let ((vault-data {
          assets: (list ),
          beneficiaries: beneficiaries,
          inactivity-period: inactivity-period,
          last-activity: (current-time),
          required-signatures: required-signatures
        }))
    (asserts! (is-none (map-get? vaults { owner: tx-sender })) (err err-already-initialized))
    (ok (map-set vaults { owner: tx-sender } vault-data))
  )
)

(define-public (deposit-asset (asset principal))
  (let ((vault (unwrap! (map-get? vaults { owner: tx-sender }) (err err-not-found))))
    (let ((new-assets (unwrap! (as-max-len? (append (get assets vault) asset) u100) (err err-asset-limit-reached))))
      (ok (map-set vaults
        { owner: tx-sender }
        (merge vault {
          assets: new-assets,
          last-activity: (current-time)
        })
      ))
    )
  )
)

(define-public (update-activity)
  (let ((vault (unwrap! (map-get? vaults { owner: tx-sender }) (err err-not-found))))
    (ok (map-set vaults
      { owner: tx-sender }
      (merge vault { last-activity: (current-time) })
    ))
  )
)

(define-public (authorize-signer (signer principal))
  (let ((vault (unwrap! (map-get? vaults { owner: tx-sender }) (err err-not-found))))
    (ok (map-set authorized-signers
      { vault-owner: tx-sender, signer: signer }
      { authorized: true }
    ))
  )
)

(define-public (initiate-transfer (vault-owner principal))
  (let ((vault (unwrap! (map-get? vaults { owner: vault-owner }) (err err-not-found))))
    (asserts! (is-inactive vault) (err err-unauthorized))
    (ok (map-set pending-transfers
      { vault-owner: vault-owner }
      {
        initiated-at: (current-time),
        signatures: (list tx-sender)
      }
    ))
  )
)

(define-public (sign-transfer (vault-owner principal))
  (let (
    (vault (unwrap! (map-get? vaults { owner: vault-owner }) (err err-not-found)))
    (pending-transfer (unwrap! (map-get? pending-transfers { vault-owner: vault-owner }) (err err-not-found)))
    (signer-auth (default-to { authorized: false } (map-get? authorized-signers { vault-owner: vault-owner, signer: tx-sender })))
  )
    (asserts! (get authorized signer-auth) (err err-unauthorized))
    (asserts! (is-inactive vault) (err err-unauthorized))
    (let ((updated-signatures (unwrap! (as-max-len? (append (get signatures pending-transfer) tx-sender) u5) (err err-insufficient-signatures))))
      (ok (map-set pending-transfers
        { vault-owner: vault-owner }
        (merge pending-transfer { signatures: updated-signatures })
      ))
    )
  )
)

(define-public (execute-transfer (vault-owner principal))
  (let (
    (vault (unwrap! (map-get? vaults { owner: vault-owner }) (err err-not-found)))
    (pending-transfer (unwrap! (map-get? pending-transfers { vault-owner: vault-owner }) (err err-not-found)))
  )
    (asserts! (is-inactive vault) (err err-unauthorized))
    (asserts! (>= (len (get signatures pending-transfer)) (get required-signatures vault)) (err err-insufficient-signatures))
    (map-delete vaults { owner: vault-owner })
    (map-delete pending-transfers { vault-owner: vault-owner })
    (ok true)
  )
)

;; Read-only Functions
(define-read-only (get-vault-info (owner principal))
  (ok (unwrap! (map-get? vaults { owner: owner }) (err err-not-found)))
)

(define-read-only (get-pending-transfer (vault-owner principal))
  (ok (unwrap! (map-get? pending-transfers { vault-owner: vault-owner }) (err err-not-found)))
)