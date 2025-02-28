namespace rcap.db;

// Importing commonly used data types and features from SAP CDS (Core Data Services)
using {
    cuid, // Generates a globally unique ID automatically for each record
    managed, // Adds automatic fields like createdBy, createdAt, modifiedBy, modifiedAt
    temporal, // Adds fields to store historical changes in records
    Currency // Standard currency type (e.g., USD, EUR)
} from '@sap/cds/common';
using {RCAP.common} from './common';

// Defining a custom type for a universally unique identifier (UUID format)
type Guid : String(32);

// "context master" groups entities that contain master data (static information that doesn't change often)
context master {
    // Entity for storing business partner (customer, supplier, etc.) details

    annotate businesspartner with {
        NODE_KEY @title: '{i18n>bp_key}';
        BP_ROLE  @title: '{i18n>bp_role}';
        COMPANY_NAME @title : '{i18n>company_name}';
        BP_ID @title : '{i18n>bp_id}';
        EMAIL_ADDRESS @title : '{i18n>email_address}'
    };

    entity businesspartner : cuid {
        key NODE_KEY      : Guid; // Unique identifier for each business partner
            BP_ROLE       : String(2); // Defines the role of the business partner (e.g., supplier, customer)
            EMAIL_ADDRESS : String(105); // Stores email address
            PHONE_NUMBER  : String(32); // Stores phone number
            FAX_NUMBER    : String(32); // Stores fax number (if applicable)
            WEB_ADDRESS   : String(44); // Stores website URL
            ADDRESS_GUID  : Association to address; // Links to the address entity
            BP_ID         : String(32); // Stores the unique business partner ID
            COMPANY_NAME  : String(256); // Stores the name of the company
    }

    // Entity for storing address details
    entity address {
        key NODE_KEY        : Guid; // Unique identifier for the address
            CITY            : String(64); // Stores city name
            POSTAL_CODE     : String(14); // Stores postal/ZIP code
            STREET          : String(64); // Stores street name
            BUILDING        : String(64); // Stores building or house number
            COUNTRY         : String(2); // Stores country code (e.g., US, IN)
            ADDRESS_TYPE    : String; // Defines the type of address (e.g., billing, shipping)
            VAL_START_DATE  : Date; // The start date from which the address is valid
            VAL_END_DATE    : Date; // The end date until which the address is valid
            LATITUDE        : Decimal; // Stores latitude for mapping purposes
            LONGITUDE       : Decimal; // Stores longitude for mapping purposes
            businesspartner : Association to one businesspartner
                                  on businesspartner.ADDRESS_GUID = $self; // Links back to the business partner who owns this address
    }

    // Entity for storing product-related text descriptions
    // entity prodtext {
    //     key NODE_KEY   : Guid; // Unique identifier for the text
    //         PARENT_KEY : Guid; // Links to the parent product
    //         LANGUAGE   : String(2); // Stores language code (e.g., EN, DE)
    //         TEXT       : String(256); // Stores the actual product description
    // }

    // Entity for storing product details
    entity product {
        key NODE_KEY       : common.Guid; // Unique identifier for the product
            PRODUCT_ID     : String(28); // Stores product ID
            TYPE_CODE      : String(2); // Defines product type (e.g., physical, digital)
            CATEGORY       : String(64); // Stores category of the product (e.g., electronics, furniture)
            SUPPLIER_GUID  : Association to master.businesspartner; // Links to the supplier of the product
            TAX_TARIF_CODE : String(2); // Stores tax code applicable to the product
            MEASURE_UNIT   : String(16); // Stores unit of measurement (e.g., kg, liter)
            WEIGHT_MEASURE : String(16); // Stores product weight
            WEIGHT_UNIT    : String(16); // Stores unit for weight (e.g., kg, lb)
            CURRENCY_CODE  : String(16); // Stores currency (e.g., USD, INR)
            PRICE          : Decimal(15, 2); // Stores product price with two decimal places
            WIDTH          : Decimal(5, 2); // Stores product width
            DEPTH          : Decimal(5, 2); // Stores product depth
            HEIGHT         : Decimal(5, 2); // Stores product height
            DIM_UNIT       : String(16); // Stores dimension unit (e.g., cm, inches)
            DESCRIPTION    : localized String(255) // Stores product description
    }

    // Entity for storing employee details
    entity employees : cuid {
        nameFirst     : String(40); // Employee's first name
        nameMiddle    : String(40); // Employee's middle name
        nameLast      : String(40); // Employee's last name
        nameInitials  : String(40); // Initials of the employee's name
        sex           : common.Gender; // Stores gender information
        language      : String(1); // Stores preferred language
        phoneNumber   : common.PhoneNumber; // Stores employee's phone number
        email         : common.Email; // Stores email address
        loginName     : String(12); // Stores system login name
        Currency      : Currency; // Stores currency used for salary payments
        salaryAmount  : common.AmountT; // Stores employee salary
        accountNumber : String(16); // Stores bank account number
        bankId        : String(8); // Stores bank identifier
        bankName      : String(64); // Stores bank name
    }
}

// "context transaction" groups entities related to transactional data (data that changes frequently)
context transaction {
    // Entity for storing purchase order details
    entity purchaseorder : common.Amount, cuid {
        PO_ID            : String(24); // Stores purchase order ID
        PARTNER_GUID     : Association to master.businesspartner; // Links to the business partner placing the order
        LIFECYCLE_STATUS : String(1); // Stores status of the purchase order (e.g., open, closed)
        OVERALL_STATUS   : String(1); // Stores overall completion status of the purchase order
        ITEMS            : Association to many poitems
                               on ITEMS.PARENT_KEY = $self; // Links to multiple purchase order items
    }

    // Entity for storing individual items in a purchase order
    entity poitems : common.Amount, cuid {
        PARENT_KEY   : Association to purchaseorder; // Links to the parent purchase order
        PO_ITEM_POS  : Integer; // Stores the item position in the order
        PRODUCT_GUID : Association to master.product; // Links to the product being purchased
    }
}
