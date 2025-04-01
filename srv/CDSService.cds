using {RCAP.db.CDSView} from '../db/CDSView';
using {
    rcap.db.master,
    rcap.db.transaction
} from '../db/datamodel';


service CDSService @(path: '/CatalogService') {

    entity POWorklist       as projection on CDSView.POWorklist;
    entity ProductOrders    as projection on CDSView.ProductView;
    entity PurchaseOrderSet as projection on CDSView.POWorklist;
    entity ItemView         as projection on CDSView.ItemView;
    entity ProductSet       as projection on CDSView.ProductView;
    entity ProductSales     as projection on CDSView.CProductValuesView;

}
