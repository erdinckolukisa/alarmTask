# TorAlarm Technical Task
## Erdinc Kolukisa
### erdinckolukisa@gmail.com
## XCode 12.4 is used for development
## Tested using iphone 7 (14.3) and simulators.

## Description
The application allows user to select a category of news and read news under selected categories. The user also can search news by using search tool. 

## Application Usage
When the app is on the user will see categories screen and search tool. User can select a category to display news under that category or make a search with the keyword s/he wants to find the news. Search will start after 1 second user stops writing. If user selects a news then s/he will be redirected the detail screen and read the detail of the news in this screen. 

## Note for reviewers

I have applied MVVM design pattern. I have chosen this pattern because it allows to write more clean and decoupled code. 
I used XIB files for UITableViewCells. I think it is a good way to use same UI for other screens too.
In project I have used storyboards but I didn't prefer using segues to use DI (Dependency Injection) more effectively. 
In first screen (CategoryViewController) I used UITableView to display categories and also UISearchController to allow user to make search in news. Search will start after user stops writing. By this way I targeted not to cause a performance issue.  Search results will be displayed in a UITableViewController. 
In second screen (NewsListViewController) I used again UITableView. In this screen user can see all the news 10 by 10 with scrolling to the bottom of the screen. Also user can refresh the list by pulling the list all the way down. If user selects a news then s/he will be directed to detail screen (NewsDetailViewcontroller). In this screen user can see news details in a WebKit. 
I prefer simple error handling by displaying API error message (in usual it is not neccessary to show this message to end user) for the project but we could also handle according to http status code seperately and we could use code key that api returns in respone.

Important Note: I could't find a categories API in the documentation. That is why I manually add given categories in API documentation. That is why in CategoryListViewModel class StubApi is used. 








