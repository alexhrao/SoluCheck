%The Rectangle Formula
%The purpose of this function is to return the area and perimeter of a
%rectangle, given its height and width.

%{
    Test Cases:
   [area1, perim1] = rectangleMath(2, 2)
       area1 => 4
       perim1 => 8

   [area2, perim2] = rectangleMath(3,0.8)
       area2 => 2.4000
       perim2 => 7.6000

   [area3, perim3] = rectangleMath(7.2, 4.1)
       area3 => 29.5200
       perim3 => 22.6000

    [area4, perim4] = rectangleMath('Hello', 'World!')
        area4 = 'Only numeric values!'
        perim4 = 'Only numeric values!'

    [area5, perim5] = rectangleMath(-5, 5)
        area4 = 25
        perim5 = 20
%}


function [iArea, iPerim] = rectangleMath(iWidth, iHeight)
%{
Inventory:
    iWidth --> Width of rectangle; number
    iHeight --> Height of rectangle; number

    iArea --> Resulting area of rectangle, in square units; a number
    iPerim --> Resulting perimeter of rectangle, in units; a number
%}
%check if either argument is non-numeric
    %Calculate the area and perimeter
        iArea = iWidth * iHeight;
        iPerim = 2*(iWidth + iHeight);
end