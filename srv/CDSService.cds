using { RCAP.db.CDSView  } from '../db/CDSView';


service CDSService @(path: '/CatalogService')  {

    entity POWorklist as projection on CDSView.POWorklist;


}