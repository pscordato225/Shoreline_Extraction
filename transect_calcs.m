clear all

%Theta of the shoreline
theta= 41.946472458588296

%This is the x point before the first x starting point for the transects
sp_x= 56.281151879007744;

%Calculate the starting and ending x points so they are 5 m apart 
for i= 1:48
    
    transects(i,1).x= sp_x+ 3.718848120992257;
    sp_x= transects(i,1).x;
    x_coordinates(i, 1)= transects(i, 1).x

    %Calculate the end x points so the starting and ending poits are 80 m apart  
    transects(i,2).x= sp_x+ 90
    ep_x= transects(i, 2).x
    x_coordinates(i, 2)= transects(i, 2).x

end




%Calculate the starting y points so they are 5 m apart 
sp_y= -28.657819775506958

for i= 1:15
    
    %Calculating the start points so they are 5 m apart
    transects(i,1).y=  sp_y-3.342180224493041
    sp_y= transects(i,1).y;
    y_coordinates(i, 1)= transects(i,1).y;
    
    %Calculating the end points so they are 80 m apart 
    transects(i, 2).y= sp_y+60
    ep_y= transects(i, 2).y
    y_coordinates(i, 2)= transects(i,2).y;
    
end


for i= 16:30 
    
    %Calculating the start points so they are 5 m apart
    transects(i,1).y=  sp_y-3.342180224493041
    sp_y= transects(i,1).y;
    y_coordinates(i, 1)= transects(i,1).y;
    
    %Calculating the end points so they are 80 m apart 
    transects(i, 2).y= sp_y+90
    ep_y= transects(i, 2).y
    y_coordinates(i, 2)= transects(i,2).y;
end


transects= transpose(transects)
x_coordinates= transpose(x_coordinates)
y_coordinates= transpose(y_coordinates)
% x_coordinates= transects.x;
% y_coordinates= transects.y;

