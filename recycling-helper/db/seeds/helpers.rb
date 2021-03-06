def eval_city_csv(row)
  row = row.to_hash
  if row['ZipCodeType'] == 'STANDARD' && row['LocationType'] == 'PRIMARY' && row['Decommisioned'] == 'false'
    city = City.find_by location_id: row['Location']

    unless city
      unless row['City'] && row['State'] && row['Lat'] && row['Long'] && row['Location']
        Rails.logger.fatal "Missing data in row: #{row}"
      end

      city = City.create! name: row['City'].titleize,
                          state: Geography.abbreviation_to_state(row['State']),
                          latitude: row['Lat'].to_f,
                          longitude: row['Long'].to_f,
                          location_id: row['Location']
    end

    city.zip_codes.create! name: row['Zipcode']
    city.save!
  end
end
