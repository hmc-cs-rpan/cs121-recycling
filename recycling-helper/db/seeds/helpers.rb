def eval_city_csv(row)
  row = row.to_hash
  if row['ZipCodeType'] == 'STANDARD' && row['LocationType'] == 'PRIMARY' && row['Decommisioned'] == 'false'
    city = City.find_by location_id: row['Location']

    unless city
      city = City.create! name: row['City'].titleize,
                          state: Geography.abbreviation_to_state(row['State']),
                          location_id: row['Location']
    end

    city.zip_codes.create! name: row['Zipcode']
    city.save!
  end
end
