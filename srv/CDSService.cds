using { RCAP.db.CDSView  } from '../db/CDSView';


service CDSService {

    entity POWorklist as projection on CDSView.POWorklist;

}