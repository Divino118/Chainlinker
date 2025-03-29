;; Crosschain Gateaway Bridge Smart Contract
;; A unified hub for inter-blockchain communication
;; description: This contract manages tracking blockchain networks, bridges, and cross-network assets.


;; Error codes
(define-constant ERR-UNAUTHORIZED (err u100))
(define-constant ERR-DUPLICATE-ENTRY (err u101))
(define-constant ERR-MISSING-ENTRY (err u102))
(define-constant ERR-INVALID-NETWORK (err u103))

;; Contract administrator
(define-constant CONTRACT-ADMIN tx-sender)

;; Data structures
;; Network Directory - stores information about supported blockchains
(define-map network-directory
  { net-id: uint }
  {
    net-label: (string-ascii 32),
    net-mode: (string-ascii 16),  ;; "operational", "suspended", "discontinued"
    net-bridge: principal
  }
)

;; Bridge Directory - stores information about network bridges
(define-map bridge-directory
  { bridge-agent: principal }
  {
    bridge-net-id: uint,
    bridge-mechanism: (string-ascii 16),  ;; "validator", "relay", "merkle"
    bridge-mode: (string-ascii 16)  ;; "operational", "suspended", "discontinued"
  }
)

;; Access control - check if sender is contract administrator
(define-private (is-admin)
  (is-eq tx-sender CONTRACT-ADMIN)
)

;; Track a new blockchain network
(define-public (track-network 
  (net-id uint) 
  (net-label (string-ascii 32))
  (net-bridge principal)
)
  (begin
    (asserts! (is-admin) ERR-UNAUTHORIZED)
    (asserts! (is-none (map-get? network-directory { net-id: net-id })) ERR-DUPLICATE-ENTRY)
    
    (map-set network-directory
      { net-id: net-id }
      {
        net-label: net-label,
        net-mode: "operational",
        net-bridge: net-bridge
      }
    )
    (ok net-id)
  )
)

;; Modify network operational mode
(define-public (modify-network-mode (net-id uint) (updated-mode (string-ascii 16)))
  (let (
    (network-data (unwrap! (map-get? network-directory { net-id: net-id }) ERR-MISSING-ENTRY))
  )
    (asserts! (is-admin) ERR-UNAUTHORIZED)
    
    (map-set network-directory
      { net-id: net-id }
      (merge network-data { net-mode: updated-mode })
    )
    (ok net-id)
  )
)

;; Bridge management functions
;; Track a new bridge
(define-public (track-bridge 
  (bridge-agent principal) 
  (net-id uint) 
  (bridge-mechanism (string-ascii 16))
)
  (begin
    (asserts! (is-admin) ERR-UNAUTHORIZED)
    (asserts! (is-none (map-get? bridge-directory { bridge-agent: bridge-agent })) ERR-DUPLICATE-ENTRY)
    (asserts! (is-some (map-get? network-directory { net-id: net-id })) ERR-INVALID-NETWORK)
    
    (map-set bridge-directory
      { bridge-agent: bridge-agent }
      {
        bridge-net-id: net-id,
        bridge-mechanism: bridge-mechanism,
        bridge-mode: "operational"
      }
    )
    (ok bridge-agent)
  )
)

;; Modify bridge operational mode
(define-public (modify-bridge-mode (bridge-agent principal) (updated-mode (string-ascii 16)))
  (let (
    (bridge-data (unwrap! (map-get? bridge-directory { bridge-agent: bridge-agent }) ERR-MISSING-ENTRY))
  )
    (asserts! (is-admin) ERR-UNAUTHORIZED)
    
    (map-set bridge-directory
      { bridge-agent: bridge-agent }
      (merge bridge-data { bridge-mode: updated-mode })
    )
    (ok bridge-agent)
  )
)

;; Read-only functions
;; Retrieve network information
(define-read-only (fetch-network-data (net-id uint))
  (map-get? network-directory { net-id: net-id })
)

;; Retrieve bridge information
(define-read-only (fetch-bridge-data (bridge-agent principal))
  (map-get? bridge-directory { bridge-agent: bridge-agent })
)

;; Verify if a network is operational
(define-read-only (is-network-operational (net-id uint))
  (match (map-get? network-directory { net-id: net-id })
    network-data (is-eq (get net-mode network-data) "operational")
    false
  )
)