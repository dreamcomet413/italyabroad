# CountrySelect
module ActionView
  module Helpers
    module FormOptionsHelper
      # Return select and option tags for the given object and method, using country_options_for_select to generate the list of option tags.
      def custom_country_select(object, method, priority_countries = nil, options = {}, html_options = {})
        InstanceTag.new(object, method, self, options.delete(:object)).custom_to_country_select_tag(priority_countries, options, html_options).html_safe
      end
      # Returns a string of option tags for pretty much any country in the world. Supply a country name as +selected+ to
      # have it marked as the selected option tag. You can also supply an array of countries as +priority_countries+, so
      # that they will be listed above the rest of the (long) list.
      #
      # NOTE: Only the option tags are returned, you have to wrap this call in a regular HTML select tag.
      def custom_country_options_for_select(selected = nil, priority_countries = nil)
        country_options = ""

        if priority_countries
          country_options += options_for_select(priority_countries, selected)
          country_options += "<option value=\"\" disabled=\"disabled\">-------------</option>\n"
        end

        return (country_options + options_for_select(COUNTRIES, selected)).html_safe
      end
      # All the countries included in the country_options output.

=begin
      COUNTRIES = ["Afghanistan", "Aland Islands", "Albania", "Algeria", "American Samoa", "Andorra", "Angola",
        "Anguilla", "Antarctica", "Antigua And Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria",
        "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin",
        "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegowina", "Botswana", "Bouvet Island", "Brazil",
        "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia",
        "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China",
        "Christmas Island", "Cocos (Keeling) Islands", "Colombia", "Comoros", "Congo",
        "Congo, the Democratic Republic of the", "Cook Islands", "Costa Rica", "Cote d'Ivoire", "Croatia", "Cuba",
        "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "Ecuador", "Egypt",
        "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands (Malvinas)",
        "Faroe Islands", "Fiji", "Finland", "France", "French Guiana", "French Polynesia",
        "French Southern Territories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guernsey", "Guinea",
        "Guinea-Bissau", "Guyana", "Haiti", "Heard and McDonald Islands", "Holy See (Vatican City State)",
        "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran, Islamic Republic of", "Iraq",
        "Ireland", "Isle of Man", "Israel", "Italy", "Jamaica", "Japan", "Jersey", "Jordan", "Kazakhstan", "Kenya",
        "Kiribati", "Korea, Democratic People's Republic of", "Korea, Republic of", "Kuwait", "Kyrgyzstan",
        "Lao People's Democratic Republic", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libyan Arab Jamahiriya",
        "Liechtenstein", "Lithuania", "Luxembourg", "Macao", "Macedonia, The Former Yugoslav Republic Of",
        "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique",
        "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia, Federated States of", "Moldova, Republic of",
        "Monaco", "Mongolia", "Montenegro", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru",
        "Nepal", "Netherlands", "Netherlands Antilles", "New Caledonia", "New Zealand", "Nicaragua", "Niger",
        "Nigeria", "Niue", "Norfolk Island", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau",
        "Palestinian Territory, Occupied", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines",
        "Pitcairn", "Poland", "Portugal", "Puerto Rico", "Qatar", "Reunion", "Romania", "Russian Federation",
        "Rwanda", "Saint Barthelemy", "Saint Helena", "Saint Kitts and Nevis", "Saint Lucia",
        "Saint Pierre and Miquelon", "Saint Vincent and the Grenadines", "Samoa", "San Marino",
        "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore",
        "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa",
        "South Georgia and the South Sandwich Islands", "Spain", "Sri Lanka", "Sudan", "Suriname",
        "Svalbard and Jan Mayen", "Swaziland", "Sweden", "Switzerland", "Syrian Arab Republic",
        "Taiwan, Province of China", "Tajikistan", "Tanzania, United Republic of", "Thailand", "Timor-Leste",
        "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan",
        "Turks and Caicos Islands", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom",
        "United States", "United States Minor Outlying Islands", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela",
        "Viet Nam", "Virgin Islands, British", "Virgin Islands, U.S.", "Wallis and Futuna", "Western Sahara",
        "Yemen", "Zambia", "Zimbabwe"] unless const_defined?("COUNTRIES")
=end


COUNTRIES = [["AFGHANISTAN", "AF"], ["ALBANIA", "AL"], ["ALGERIA", "DZ"], ["AMERICAN SAMOA", "AS"], ["ANDORRA", "AD"], ["ANGOLA", "AO"], ["ANGUILLA", "AI"], ["ANTARCTICA", "AQ"], ["ANTIGUA AND BARBUDA", "AG"], ["ARGENTINA", "AR"], ["ARMENIA", "AM"], ["ARUBA", "AW"], ["AUSTRALIA", "AU"], ["AUSTRIA", "AT"], ["AZERBAIJAN", "AZ"], ["BAHAMAS", "BS"], ["BAHRAIN", "BH"], ["BANGLADESH", "BD"], ["BARBADOS", "BB"], ["BELARUS", "BY"], ["BELGIUM", "BE"], ["BELIZE", "BZ"], ["BENIN", "BJ"], ["BERMUDA", "BM"], ["BHUTAN", "BT"], ["BOLIVIA", "BO"], ["BOSNIA AND HERZEGOVINA", "BA"], ["BOTSWANA", "BW"], ["BOUVET ISLAND", "BV"], ["BRAZIL", "BR"], ["BRITISH INDIAN OCEAN TERRITORY", "IO"], ["BRUNEI DARUSSALAM", "BN"], ["BULGARIA", "BG"], ["BURKINA FASO", "BF"], ["BURUNDI", "BI"], ["CAMBODIA", "KH"], ["CAMEROON", "CM"], ["CANADA", "CA"], ["CAPE VERDE", "CV"], ["CAYMAN ISLANDS", "KY"], ["CENTRAL AFRICAN REPUBLIC", "CF"], ["CHAD", "TD"], ["CHILE", "CL"], ["CHINA", "CN"], ["CHRISTMAS ISLAND", "CX"], ["COCOS (KEELING) ISLANDS", "CC"], ["COLOMBIA", "CO"], ["COMOROS", "KM"], ["CONGO", "CG"], ["CONGO, THE DEMOCRATIC REPUBLIC OF THE", "CD"], ["COOK ISLANDS", "CK"], ["COSTA RICA", "CR"], ["COTE D'IVOIRE", "CI"], ["CROATIA", "HR"], ["CUBA", "CU"], ["CYPRUS", "CY"], ["CZECH REPUBLIC", "CZ"], ["DENMARK", "DK"], ["DJIBOUTI", "DJ"], ["DOMINICA", "DM"], ["DOMINICAN REPUBLIC", "DO"], ["ECUADOR", "EC"], ["EGYPT", "EG"], ["EL SALVADOR", "SV"], ["EQUATORIAL GUINEA", "GQ"], ["ERITREA", "ER"], ["ESTONIA", "EE"], ["ETHIOPIA", "ET"], ["FALKLAND ISLANDS (MALVINAS)", "FK"], ["FAROE ISLANDS", "FO"], ["FIJI", "FJ"], ["FINLAND", "FI"], ["FRANCE", "FR"], ["FRENCH GUIANA", "GF"], ["FRENCH POLYNESIA", "PF"], ["FRENCH SOUTHERN TERRITORIES", "TF"], ["GABON", "GA"], ["GAMBIA", "GM"], ["GEORGIA", "GE"], ["GERMANY", "DE"], ["GHANA", "GH"], ["GIBRALTAR", "GI"], ["GREECE", "GR"], ["GREENLAND", "GL"], ["GRENADA", "GD"], ["GUADELOUPE", "GP"], ["GUAM", "GU"], ["GUATEMALA", "GT"], ["GUINEA", "GN"], ["GUINEA-BISSAU", "GW"], ["GUYANA", "GY"], ["HAITI", "HT"], ["HEARD ISLAND AND MCDONALD ISLANDS", "HM"], ["HOLY SEE (VATICAN CITY STATE)", "VA"], ["HONDURAS", "HN"], ["HONG KONG", "HK"], ["HUNGARY", "HU"], ["ICELAND", "IS"], ["INDIA", "IN"], ["INDONESIA", "ID"], ["IRAN, ISLAMIC REPUBLIC OF", "IR"], ["IRAQ", "IQ"], ["IRELAND", "IE"], ["ISRAEL", "IL"], ["ITALY", "IT"], ["JAMAICA", "JM"], ["JAPAN", "JP"], ["JORDAN", "JO"], ["KAZAKHSTAN", "KZ"], ["KENYA", "KE"], ["KIRIBATI", "KI"], ["KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF", "KP"], ["KOREA, REPUBLIC OF", "KR"], ["KUWAIT", "KW"], ["KYRGYZSTAN", "KG"], ["LAO PEOPLE'S DEMOCRATIC REPUBLIC", "LA"], ["LATVIA", "LV"], ["LEBANON", "LB"], ["LESOTHO", "LS"], ["LIBERIA", "LR"], ["LIBYAN ARAB JAMAHIRIYA", "LY"], ["LIECHTENSTEIN", "LI"], ["LITHUANIA", "LT"], ["LUXEMBOURG", "LU"], ["MACAO", "MO"], ["MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF", "MK"], ["MADAGASCAR", "MG"], ["MALAWI", "MW"], ["MALAYSIA", "MY"], ["MALDIVES", "MV"], ["MALI", "ML"], ["MALTA", "MT"], ["MARSHALL ISLANDS", "MH"], ["MARTINIQUE", "MQ"], ["MAURITANIA", "MR"], ["MAURITIUS", "MU"], ["MAYOTTE", "YT"], ["MEXICO", "MX"], ["MICRONESIA, FEDERATED STATES OF", "FM"], ["MOLDOVA, REPUBLIC OF", "MD"], ["MONACO", "MC"], ["MONGOLIA", "MN"], ["MONTSERRAT", "MS"], ["MOROCCO", "MA"], ["MOZAMBIQUE", "MZ"], ["MYANMAR", "MM"], ["NAMIBIA", "NA"], ["NAURU", "NR"], ["NEPAL", "NP"], ["NETHERLANDS", "NL"], ["NETHERLANDS ANTILLES", "AN"], ["NEW CALEDONIA", "NC"], ["NEW ZEALAND", "NZ"], ["NICARAGUA", "NI"], ["NIGER", "NE"], ["NIGERIA", "NG"], ["NIUE", "NU"], ["NORFOLK ISLAND", "NF"], ["NORTHERN MARIANA ISLANDS", "MP"], ["NORWAY", "NO"], ["OMAN", "OM"], ["PAKISTAN", "PK"], ["PALAU", "PW"], ["PALESTINIAN TERRITORY, OCCUPIED", "PS"], ["PANAMA", "PA"], ["PAPUA NEW GUINEA", "PG"], ["PARAGUAY", "PY"], ["PERU", "PE"], ["PHILIPPINES", "PH"], ["PITCAIRN", "PN"], ["POLAND", "PL"], ["PORTUGAL", "PT"], ["PUERTO RICO", "PR"], ["QATAR", "QA"], ["REUNION", "RE"], ["ROMANIA", "RO"], ["RUSSIAN FEDERATION", "RU"], ["RWANDA", "RW"], ["SAINT HELENA", "SH"], ["SAINT KITTS AND NEVIS", "KN"], ["SAINT LUCIA", "LC"], ["SAINT PIERRE AND MIQUELON", "PM"], ["SAINT VINCENT AND THE GRENADINES", "VC"], ["SAMOA", "WS"], ["SAN MARINO", "SM"], ["SAO TOME AND PRINCIPE", "ST"], ["SAUDI ARABIA", "SA"], ["SENEGAL", "SN"], ["SERBIA AND MONTENEGRO", "CS"], ["SEYCHELLES", "SC"], ["SIERRA LEONE", "SL"], ["SINGAPORE", "SG"], ["SLOVAKIA", "SK"], ["SLOVENIA", "SI"], ["SOLOMON ISLANDS", "SB"], ["SOMALIA", "SO"], ["SOUTH AFRICA", "ZA"], ["SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS", "GS"], ["SPAIN", "ES"], ["SRI LANKA", "LK"], ["SUDAN", "SD"], ["SURINAME", "SR"], ["SVALBARD AND JAN MAYEN", "SJ"], ["SWAZILAND", "SZ"], ["SWEDEN", "SE"], ["SWITZERLAND", "CH"], ["SYRIAN ARAB REPUBLIC", "SY"], ["TAIWAN, PROVINCE OF CHINA", "TW"], ["TAJIKISTAN", "TJ"], ["TANZANIA, UNITED REPUBLIC OF", "TZ"], ["THAILAND", "TH"], ["TIMOR-LESTE", "TL"], ["TOGO", "TG"], ["TOKELAU", "TK"], ["TONGA", "TO"], ["TRINIDAD AND TOBAGO", "TT"], ["TUNISIA", "TN"], ["TURKEY", "TR"], ["TURKMENISTAN", "TM"], ["TURKS AND CAICOS ISLANDS", "TC"], ["TUVALU", "TV"], ["UGANDA", "UG"], ["UKRAINE", "UA"], ["UNITED ARAB EMIRATES", "AE"], ["UNITED KINGDOM", "GB"], ["UNITED STATES", "US"], ["UNITED STATES MINOR OUTLYING ISLANDS", "UM"], ["URUGUAY", "UY"], ["UZBEKISTAN", "UZ"], ["VANUATU", "VU"], ["VENEZUELA", "VE"], ["VIET NAM", "VN"], ["VIRGIN ISLANDS, BRITISH", "VG"], ["VIRGIN ISLANDS, U.S.", "VI"], ["WALLIS AND FUTUNA", "WF"], ["WESTERN SAHARA", "EH"], ["YEMEN", "YE"], ["ZAMBIA", "ZM"], ["ZIMBABWE", "ZW"]] unless const_defined?("COUNTRIES")



    end

    class InstanceTag
      def custom_to_country_select_tag(priority_countries, options, html_options)
        html_options = html_options.stringify_keys
        add_default_name_and_id(html_options)
        value = value(object)
        content_tag("select",
          add_options(
            custom_country_options_for_select(value, priority_countries),
            options, value
          ), html_options
        ).html_safe
      end
    end

    class FormBuilder
      def custom_country_select(method, priority_countries = nil, options = {}, html_options = {})
        @template.custom_country_select(@object_name, method, priority_countries, options.merge(:object => @object), html_options).html_safe
      end
    end
  end
end

