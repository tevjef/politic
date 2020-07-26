import {
  VoterInformation,
  CheckRegistrationResponse,
} from "../model/VoterRegistration";
import puppeteer from "puppeteer";

export class NewYorkRegistrationService {
  titleCase(str: string): string {
    const a = str.toLowerCase().split(" ");
    for (let i = 0; i < str.length; i++) {
      a[i] = str[i].charAt(0).toUpperCase() + str[i].slice(1);
    }

    return a.join(" ");
  }

  async checkStatus(
    voterInformation: VoterInformation
  ): Promise<CheckRegistrationResponse> {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    console.log("goto page");
    await page.goto("https://voterlookup.elections.ny.gov/");
    await page.select("#county", counties[voterInformation.county]);

    await page.focus("#fname")
    await page.keyboard.type(voterInformation.firstName);

    await page.focus("#lname")
    await page.keyboard.type(voterInformation.lastName);

    await page.focus("#dob");
    await page.keyboard.type(
      `${voterInformation.month}/${voterInformation.day}/${voterInformation.year}`
    );

    await page.focus("#zip")
    await page.keyboard.type(voterInformation.zipcode);

    await page.click("#submitbtn", { clickCount: 2, delay: 400 });
    await page.screenshot({ path: "ss-final.png" });

    await page.evaluate(() => document.body.textContent);
    // console.log(bodyHTML);
    return {
      voterStatus: {
        type: "singleEnrolled",
        value: [],
      },
    };
  }
}

const counties: { [name: string]: string } = {
  Albany: "01",
  Allegany: "02",
  Bronx: "03",
  Broome: "04",
  Cattaraugus: "05",
  Cayuga: "06",
  Chautauqua: "07",
  Chemung: "08",
  Chenango: "09",
  Clinton: "10",
  Columbia: "11",
  Cortland: "12",
  Delaware: "13",
  Dutchess: "14",
  Erie: "15",
  Essex: "16",
  Franklin: "17",
  Fulton: "18",
  Genesee: "19",
  Greene: "20",
  Hamilton: "21",
  Herkimer: "22",
  Jefferson: "23",
  "Kings (Brooklyn)": "24",
  Lewis: "25",
  Livingston: "26",
  Madison: "27",
  Monroe: "28",
  Montgomery: "29",
  Nassau: "30",
  "New York (ManhattaN)": "31",
  Niagara: "32",
  Oneida: "33",
  Onondaga: "34",
  Ontario: "35",
  Orange: "36",
  Orleans: "37",
  Oswego: "38",
  Otsego: "39",
  Putnam: "40",
  Queens: "41",
  Rensselaer: "42",
  "Richmond (Staten Island)": "43",
  Rockland: "44",
  Saratoga: "45",
  Schenectady: "46",
  Schoharie: "47",
  Schuyler: "48",
  Seneca: "49",
  "St.Lawrence": "50",
  Steuben: "51",
  Suffolk: "52",
  Sullivan: "53",
  Tioga: "54",
  Tompkins: "55",
  Ulster: "56",
  Warren: "57",
  Washington: "58",
  Wayne: "59",
  Westchester: "60",
  Wyoming: "61",
  Yates: "62",
};
