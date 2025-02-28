namespace RCAP.common;


using {
    sap,
    Currency,
    temporal,
    managed
} from '@sap/cds/common';

type Gender        : String(2) enum {
    male         = 'M';
    female       = 'F';
    nonBinary    = 'N';
    noDisclousre = 'D';
    selfDescribe = 'S';
};

type AmountT       : Decimal(15, 2) @(
    Semantics.amount.currencyCode: 'CURRENCY_CODE',
    sap.unit                     : 'CURRENCY_CODE'
);


aspect Amount {
    CURRENCY_CODE : String(4);
    GROSS_AMOUNT  : AmountT;
    NET_AMOUNT    : AmountT;
    TAX_AMOUNT    : AmountT;
}

type Guid: String(32);
type PhoneNumber   : String(30) @assert.format: '^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$';
type Email : String(255) @assert.format: '[A-Za-z0-9\._%+\-]+@[A-Za-z0-9\.\-]+\.[A-Za-z]{2,}';
