module Geography
  STATES = {
    'Alabama'=> 'AL',
    'Alaska' => 'AK',
    'Arizona'=> 'AZ',
    'Arkansas'   => 'AR',
    'California' => 'CA',
    'Colorado'   => 'CO',
    'Connecticut'=> 'CT',
    'Delaware'   => 'DE',
    'District of Columbia'   => 'DC',
    'Florida'=> 'FL',
    'Georgia'=> 'GA',
    'Hawaii' => 'HI',
    'Idaho'  => 'ID',
    'Illinois'   => 'IL',
    'Indiana'=> 'IN',
    'Iowa'   => 'IA',
    'Kansas' => 'KS',
    'Kentucky'   => 'KY',
    'Louisiana'  => 'LA',
    'Maine'  => 'ME',
    'Montana'=> 'MT',
    'Nebraska'   => 'NE',
    'Nevada' => 'NV',
    'New Hampshire'  => 'NH',
    'New Jersey' => 'NJ',
    'New Mexico' => 'NM',
    'New York'   => 'NY',
    'North Carolina' => 'NC',
    'North Dakota'   => 'ND',
    'Ohio'   => 'OH',
    'Oklahoma'   => 'OK',
    'Oregon' => 'OR',
    'Maryland'   => 'MD',
    'Massachusetts'  => 'MA',
    'Michigan'   => 'MI',
    'Minnesota'  => 'MN',
    'Mississippi'=> 'MS',
    'Missouri'   => 'MO',
    'Pennsylvania'   => 'PA',
    'Rhode Island'   => 'RI',
    'South Carolina' => 'SC',
    'South Dakota'   => 'SD',
    'Tennessee'  => 'TN',
    'Texas'  => 'TX',
    'Utah'   => 'UT',
    'Vermont'=> 'VT',
    'Virginia'   => 'VA',
    'Washington' => 'WA',
    'West Virginia'  => 'WV',
    'Wisconsin'  => 'WI',
    'Wyoming'=> 'WY',

    'American Samoa' => 'AS',
    'Federated States of Micronesia' => 'FM',
    'Guam' => 'GU',
    'Marshall Islands' => 'MH',
    'Northern Mariana Islands' => 'MP',
    'Palau' => 'PW',
    'Puerto Rico' => 'PR',
    'Virgin Islands' => 'VI'
  }

module_function

  def states
    STATES.keys
  end

  def state_to_abbreviation(state)
    STATES[state]
  end

  def abbreviation_to_state(abbreviation)
    state = nil
    STATES.each do |s, a|
      if a == abbreviation
        state = +s # s is a hash key and thus is frozen; we assign state to an unfrozen copy
        break
      end
    end

    Rails.logger.debug "state: #{state}"

    unless state
      Rails.logger.error "Unknown state abbreviation #{abbreviation}"
    end

    return state
  end

end
