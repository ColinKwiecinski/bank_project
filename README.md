## Webapp for visualizing transaction history from USBank
Built using R Shiny by Colin Kwiecinski  

[Link to Project](https://colinkwi.shinyapps.io/bank_project/)

Functions:
- Lets the user import a csv file containing bank records downloaded from 
USBank  
- Creates multiple visualizations from that data to track spending over time  
- Allows the user to filter down to certain transactions, using regex terms.
By default QFC and COSTCO are chosen as those are monthly expenses I wanted to
track.    
- Interactive visualizations that can be controlled

Planned Updates/TODO List:  
- Add description and usage guides to visualization controls  
- Add way to download data  
- Implement API calls to automatically download most recent data from USBank
- Add more visualizations and control options  
