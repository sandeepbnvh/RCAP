// Importing database models from the 'datamodel' file
// 'master' contains static master data like employees, addresses, products, etc.
// 'transaction' contains dynamic transactional data like purchase orders and order items.
using {
    rcap.db.master,
    rcap.db.transaction
} from '../db/datamodel';

// Defining a service called 'catalogService' which exposes various data entities
service catalogService @(path: '/CatalogService') {

    // Exposing employee data from the master database
    entity EmployeeSet as projection on master.employees;

    // Exposing address data from the master database
    entity AddressSet as projection on master.address;

    // Exposing product data from the master database
    entity ProductSet as projection on master.product;

    // The following entity (ProductTextSet) is commented out, meaning it's not available in the service
    // entity ProductTextSet as projection on master.prodtext;

    // Exposing business partner (BP) data from the master database
    entity BPSet as projection on master.businesspartner;

    // Exposing purchase orders (POs) from the transaction database
    // 'title' annotation allows multi-language support by fetching the title from the i18n (internationalization) file
    entity POs @(title: '{i18n>poHeader}') as
        projection on transaction.purchaseorder {
            *,
            // Linking purchase orders to their respective items
            ITEMS : redirected to POItems
        }

    // Exposing purchase order items (POItems) from the transaction database
    entity POItems @(title: '{i18n>poItems}') as
        projection on transaction.poitems {
            *,
            // Linking each PO item back to its parent purchase order
            PARENT_KEY   : redirected to POs,
            // Linking each PO item to its respective product in the product catalog
            PRODUCT_GUID : redirected to ProductSet
        }
}
