g = TitanFactory.open('/opt/faunus/bin/titan.properties')

sharedTxCount = g.makeKey("shared_transaction_count").dataType(Integer.class).indexed("search",Edge.class).make();
patientTotal = g.makeKey("patient_total").dataType(Integer.class).indexed("search",Edge.class).make();
sameDayTotal = g.makeKey("same_day_total").dataType(Integer.class).indexed("search",Edge.class).make();
window = g.makeKey("window").dataType(Integer.class).indexed("search",Edge.class).make();

g.makeLabel("referred").sortKey(window).make();

g.commit();
