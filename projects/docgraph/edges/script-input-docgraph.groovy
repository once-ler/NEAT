import com.thinkaurelius.faunus.FaunusVertex
import static com.tinkerpop.blueprints.Direction.OUT

/*
	Sometimes, the NPI in docgraph is alphanumeric, ie D038471110.
	When that happens, we ignore the edge record.
*/
def boolean read(FaunusVertex v, String line) {
    parts = line.split(',');
    
	if (!parts[0].isInteger() || !parts[1].isInteger()) {
		return false;
	}
	
	uid = Integer.valueOf(parts[0].trim());
	v.reuse(uid);    
	v.setProperty('uid', uid);
	
	edge = v.addEdge(OUT, 'referred', Integer.valueOf(parts[1].trim()));
	edge.setProperty('shared_transaction_count', Integer.valueOf(parts[2].trim()));
	edge.setProperty('patient_total', Integer.valueOf(parts[3].trim()));
	edge.setProperty('same_day_total', Integer.valueOf(parts[4].trim()));
	edge.setProperty('window', 365);
	
    return true;
}

