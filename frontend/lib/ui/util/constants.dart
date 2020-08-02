import 'dart:ui';

class Constants {
  static String placeholderImageUrl =
      "https://firebasestorage.googleapis.com/v0/b/byteflip-politic.appspot.com/o/app%2Fpublic%2Fplaceholder-image.png?alt=media";

  static Color colorForParty(String party) {
    if (party == null || party.isEmpty) {
      return Color(0xFF000000);
    } else if (party.toLowerCase().contains("demo")) {
      return Color(0xFF2C98F0);
    } else if (party.toLowerCase().contains("rep")) {
      return Color(0xFFF2453D);
    } else {
      return Color(0xFF000000);
    }
  }

  static var states = {
  "AL": "Alabama",
  "AK": "Alaska",
  "AZ": "Arizona",
  "AR": "Arkansas",
  "CA": "California",
  "CO": "Colorado",
  "CT": "Connecticut",
  "DE": "Delaware",
  "DC": "District of Columbia",
  "FL": "Florida",
  "GA": "Georgia",
  "HI": "Hawaii",
  "ID": "Idaho",
  "IL": "Illinois",
  "IN": "Indiana",
  "IA": "Iowa",
  "KS": "Kansas",
  "KY": "Kentucky",
  "LA": "Louisiana",
  "ME": "Maine",
  "MD": "Maryland",
  "MA": "Massachusetts",
  "MI": "Michigan",
  "MN": "Minnesota",
  "MS": "Mississippi",
  "MO": "Missouri",
  "MT": "Montana",
  "NE": "Nebraska",
  "NV": "Nevada",
  "NH": "New Hampshire",
  "NJ": "New Jersey",
  "NM": "New Mexico",
  "NY": "New York",
  "NC": "North Carolina",
  "ND": "North Dakota",
  "OH": "Ohio",
  "OK": "Oklahoma",
  "OR": "Oregon",
  "PA": "Pennsylvania",
  "RI": "Rhode Island",
  "SC": "South Carolina",
  "SD": "South Dakota",
  "TN": "Tennessee",
  "TX": "Texas",
  "UT": "Utah",
  "VT": "Vermont",
  "VA": "Virginia",
  "WA": "Washington",
  "WV": "West Virginia",
  "WI": "Wisconsin",
  "WY": "Wyoming",
  "GU": "Guam",
  "PR": "Puerto Rico",
  "AA": "U.S. Armed Forces – Americas",
  "AE": "U.S. Armed Forces – Europe",
  "AP": "U.S. Armed Forces – Pacific",
  "VI": "U.S. Virgin Islands",
};

}
