

This is a simple Sinatra app to calculate annual revenue and expense data from a CSV file.

## Running

The app can be started with
```
ruby data_parser.rb
```

## Structure

* data_parser.rb is the main file
* calculator.rb defines a class to parse a CSV file and calculate certain totals
* lib/money.rb implements a to_json method for the Money class
* views/calculate.erb provides a simple web form to upload a CSV file for processing
* test.csv is an example input file

The other files are standard.


## API

Here is an example input file:

```
Year,Month,Category ID,Category Name,Item Name,Amount
2012,12,01,Sales,Other,96000.00
2012,12,02,Supplies,Utensils,-3338.54
2012,12,02,Supplies,Chairs,-17687.71
```

A POST request to http://[host]/calculate with a `file`
parameter set to the above CSV file will return this JSON object:


```
{
  "rows_parsed" : [
    [2012,12,"01","Sales","Other",96000.0],
    [2012,12,"02","Supplies","Utensils",-3338.54],
    [2012,12,"02","Supplies","Chairs",-17687.71]
  ],
  "categorized_totals":{
      "2012":{
         "revenues":{
            "categories":{
               "Sales":96000.00,
               "Supplies":0.00
            },
            "total":96000.00
         },
         "expenses":{
            "categories":{
               "Sales":0.00,
               "Supplies":-21026.25
            },
            "total":-21026.25
         }
      }
   }
}
```

## Web Interface

The web interface can be accessed via

```
GET http://[host]/calculate
```

where the user can upload a CSV file.

## Notes

1. Category ID's are saved as strings since they're alphanumeric.
2. The API assumes a valid CSV file will be sent. Lines that start with empty fields are ignored, but otherwise no checking is performed.
3. If there are only revenues for a given year, for example, the funds and departments hashes for the expenses will have the same category names as the revenues, but with 0 values.
4. The decision to use the money gem to handle the monetary values was motivated by a desire to avoid floating point problems during calculations. To ultimately return the totals as numbers, as specified, a to_json method is added for the Money class.

