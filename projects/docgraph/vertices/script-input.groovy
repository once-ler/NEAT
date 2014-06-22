import com.thinkaurelius.faunus.FaunusVertex
import static com.tinkerpop.blueprints.Direction.OUT

def boolean read(FaunusVertex v, String line) {

	fields = ['0': 'npi',
  '1': 'entity_type_code',
  '2': 'replacement_npi',
  '3': 'employer_identification_number',
  '4': 'provider_organization_name',
  '5': 'provider_last_name',
  '6': 'provider_first_name',
  '7': 'provider_middle_name',
  '8': 'provider_name_prefix_text',
  '9': 'provider_name_suffix_text',
  '10': 'provider_credential_text',
  '11': 'provider_other_organization_name',
  '12': 'provider_other_organization_name_type_code',
  '13': 'provider_other_last_name',
  '14': 'provider_other_first_name',
  '15': 'provider_other_middle_name',
  '16': 'provider_other_name_prefix_text',
  '17': 'provider_other_name_suffix_text',
  '18': 'provider_other_credential_text',
  '19': 'provider_other_last_name_type_code',
  '20': 'provider_first_line_business_mailing_address',
  '21': 'provider_second_line_business_mailing_address',
  '22': 'provider_business_mailing_address_city_name',
  '23': 'provider_business_mailing_address_state_name',
  '24': 'provider_business_mailing_address_postal_code',
  '25': 'provider_business_mailing_address_country_code',
  '26': 'provider_business_mailing_address_telephone_number',
  '27': 'provider_business_mailing_address_fax_number',
  '28': 'provider_first_line_business_practice_location_address',
  '29': 'provider_second_line_business_practice_location_address',
  '30': 'provider_business_practice_location_address_city_name',
  '31': 'provider_business_practice_location_address_state_name',
  '32': 'provider_business_practice_location_address_postal_code',
  '33': 'provider_business_practice_location_address_country_code',
  '34': 'provider_business_practice_location_address_telephone_number',
  '35': 'provider_business_practice_location_address_fax_number',
  '36': 'provider_enumeration_date',
  '37': 'last_update_date',
  '38': 'npi_deactivation_reason_code',
  '39': 'npi_deactivation_date',
  '40': 'npi_reactivation_date',
  '41': 'provider_gender_code',
  '42': 'authorized_official_last_name',
  '43': 'authorized_official_first_name',
  '44': 'authorized_official_middle_name',
  '45': 'authorized_official_title_or_position',
  '46': 'authorized_official_telephone_number',
  '47': 'healthcare_provider_taxonomy_code_1',
  '48': 'provider_license_number_1',
  '49': 'provider_license_number_state_code_1',
  '50': 'healthcare_provider_primary_taxonomy_switch_1',
  '107': 'other_provider_identifier_1',
  '108': 'other_provider_identifier_type_code_1',
  '109': 'other_provider_identifier_state_1',
  '110': 'other_provider_identifier_issuer_1',
  '314': 'healthcare_provider_taxonomy_group_1' ];

  parts = line.split(',');
    
	npi = parts[0].replaceAll(/\"/, '').trim();
	
	if (!npi.isLong()) {
		return false;
	}
	
	uid = Long.valueOf(npi);
	
	v.reuse(uid)
    
	v.setProperty('uid', uid);
	
	parts.eachWithIndex {item, index ->
	
		i = String.valueOf(index);
		if (fields[i]){
		
			val = item.replaceAll(/\"/, '').trim();
			if (fields[i].matches(/\_date$/)){
				val = Long.valueOf(new Date(val).getTime());
			}
		
			v.setProperty(fields[i], val);
		}	
	}
	
    return true;
}

