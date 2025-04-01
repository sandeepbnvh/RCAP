using {RCAP.db.CDSView} from '../db/CDSView';
using {
    rcap.db.master,
    rcap.db.transaction
} from '../db/datamodel';


service CDSService @(path: '/CatalogService') {

    entity POWorklist as projection on CDSView.POWorklist;

  

        


}
