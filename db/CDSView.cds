// Define a namespace for the database objects in the CDS (Core Data Services) model
namespace RCAP.db;

// Import the necessary schemas from the datamodel
using {
    rcap.db.master,      // Master data schema (not used in this view)
    rcap.db.transaction  // Transactional data schema (used for purchase orders)
} from './datamodel';

// Define a CDS context to group related views
context CDSView {

    // Define a CDS view named 'POWorklist'
    define view ![POWorklist] as

        // Select required fields from the 'transaction.purchaseorder' table
        select from transaction.purchaseorder {
            
            // Key field: Unique identifier for the purchase order
            key PO_ID                             as ![PurchaseOrderId],

            // Business partner-related fields
            PARTNER_GUID.BP_ID                    as ![PartnerId],         // Business Partner ID
            PARTNER_GUID.COMPANY_NAME             as ![CompanyName],       // Company name of the partner
            
            // Purchase order financial details
            GROSS_AMOUNT                          as ![POGrossAmount],     // Total gross amount of the PO
            CURRENCY_CODE                         as ![POCurrencyCode],    // Currency of the purchase order
            LIFECYCLE_STATUS                      as ![POStatus],         // Lifecycle status of the PO (e.g., Open, Closed, Approved)
                
            // Purchase order item-level details
            
            // Key field: Unique identifier for each item within a purchase order
            key ITEMS.PO_ITEM_POS                 as ![ItemPosition],      // Item position within the PO
            
            // Product-related fields
            ITEMS.PRODUCT_GUID.PRODUCT_ID         as ![ProductID],        // Unique ID of the product
            ITEMS.PRODUCT_GUID.DESCRIPTION        as ![ProductName],      // Product description
            
            // Partner's address information
            PARTNER_GUID.ADDRESS_GUID.CITY        as ![City],             // City where the partner is located
            PARTNER_GUID.ADDRESS_GUID.COUNTRY     as ![Country],          // Country where the partner is located
            
            // Item-level financial details
            ITEMS.NET_AMOUNT                      as ![NetAmount],        // Net amount for the item (before tax)
            ITEMS.TAX_AMOUNT                      as ![TaxAmount],        // Tax amount for the item
            ITEMS.GROSS_AMOUNT                    as ![GrossAmount],      // Total gross amount for the item (net + tax)
            ITEMS.CURRENCY_CODE                   as ![CurrencyCode]      // Currency for the item pricing
        }
}
