# Ggtd


## Introduction

Ggtd is yet  another "Get Things Done" app but using GNUstep. Another name should have been  : no one should have more than 60 tasks in mind (but it was a little bit to long). 

The aim of this small app is 
 * to have a complete view of all the pending tasks, 
 * to clearly indentify the length of the tasks avec the priority
 * to be efficient when creating a new task
 * and even more...

## How it works
 
This app has first being created using a sheet of paper and a eraser : I have drawn 3 columns labelled "today", "after", "to keep in mind" and I start to note my tasks according to these description. I decide that only one face of the sheet should have to be used and due to tha avalaible space and of the size of my writing only 20 lines could then be used. 

For each tasks and using symbols derived from bullets journal, I label each task with the following  symbols for the length :
* . : a short task
* o : an moderate task
* O : a long task

I added a symbol before the length symbol to described the state of the task :
* ! : urgent
* \> : programmed
* < : started


I also plotted an horizontal line between the group of tasks on the same subject ("perso", "sport", etc.


I obtained finally a sheet with 60 tasks max classified in length, state and urgency. I decided to create the app when I was bore of erasing and rewriting one tasks from one column or row to another and changing the place of the horizontal line.

This method is thus a mix of bullet notation journal and kanban table.

## Installation

If gnustep is correctly installed on your computer : 

```make```

should build the app and 

```sudo -E make install```

should install it

## Using the app
* double-clic in a big cell let you type a new task. When a new task is create, the symbol o is attached to it
* you can click on the symbol to change the length of the task
* you can control-click on the symbol to change the state of the task
* you can rename (double-click) and move the category one the left
* you can remove of add large horizontal lines between the category : the app does not control the position of these lines according to the position of the categories.  
* preferences panel let you change the width of the columns and the size font used in the cells. 
* moving task from one place to another is perfomed usinf cut and paste.




 
 
 


