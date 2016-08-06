function guiproj3
% This gui is a game
clear functions
f=figure('Position',[360,500,1000,1000],'color','white','visible','off');
axhan=axes('parent',f,'units','normalized','position',[.15,.7,.777,.111]);
set(f,'units', 'normalized')
movegui(f, 'center')

	% image of title 
axhanimg=image(imread('Titlefinal.jpg'));

% Create pushbuttons in main menu
playh=uicontrol('style','pushbutton','units','normalized','position',...
[.4,.4,.3,.2],'backgroundcolor', [0 1 1],'string','Play','callback',...
@play);
howh=uicontrol('style','pushbutton','units','normalized','position',...
[.4,.15,.3,.2],'backgroundcolor', [0 1 1],'string','How to Play','callback',...
@howtoplay);
% Edit box to save name: can put first name or full naem
nameh=uicontrol('style', 'edit','units','normalized','position',[.05,.05,.3,.05],...
	'backgroundcolor', 'white');
smalltexth=uicontrol('style','text','units','normalized','position',[.05,0,.3,.05],...
	'string','Please enter your name');
set(f, 'visible', 'on')

scoreboard = {};
scorename = {};

% If howtoplay button is pushed
function howtoplay(~, ~)
set([playh,howh,smalltexth,nameh], 'visible', 'off')
instructh=axes('parent',f,'units','normalized','position',[.2,.2,.699,.416]);
	% image of instructions
instructimg=image(imread('Instructionsfinal.jpg'));
	
backh=uicontrol('style', 'pushbutton', 'units', 'normalized', 'backgroundcolor',...
	'white','position',[.4,.05,.2,.1], 'string', 'Go back!', 'callback',...
	@goback);
% Goes back to main menu
	function goback(~,~)
    	set([backh,instructh, instructimg], 'visible' ,'off')
    	set([playh, howh, smalltexth, nameh], 'visible', 'on')
	end
end
	
% If play button is pushed
function play(~,~) 
set([axhan,axhanimg,playh,howh,nameh, smalltexth], 'visible', 'off')
persistent noplayed
if isempty(noplayed)
    noplayed=0;
end
noplayed=noplayed+1;
% Create axes
baraxesh=axes('units', 'normalized', 'position', [.1, .1,.15,.6], 'visible', 'off');
axis(baraxesh,[0 1 0 8])
axgameh=axes('units', 'normalized', 'position', [.3,0,.7,1]);
% Create colormaps
mycolors=[1 1 .3;1 .72 .67;1 .33 .94;1 .9 .7; .7 1 .87;.96 .73 1;.91 1 1;.95 .9 .67];
mycolors2=repmat([1 1 1], 8, 1);
colorcorrect=[mycolors2; 0 1 0];
colorcorrect2=[mycolors; 0 1 0];
colormap(mycolors)
% Generate random pairs of color
mat=[1 1 2 2 3 3 4 4 5 5 6 6 7 7 8 8];
indvec=randperm(16);
mat=mat(indvec);
mat=reshape(mat,4,4);
% Display colors for 3 seconds
image(mat,'parent',axgameh )
pause(3)
colormap(mycolors2)
% Display white boxes to click
image(mat,'parent',axgameh)
set(axgameh,'xtick',[0.5:1:8.5],'ytick', [0.5:1:8.5], 'xgrid', 'on','ygrid', 'on');
% set points
totalpoints=repmat([1;0],1,8);
i=1;
j=1;
count=1;
% Create empty structure to store the correct matches the player has alraedy chosen
clicked(1)=struct('point1', [0 0], 'point2', [0 0]);
while i<=8
    % Get players choices
    [y1, x1]=ginput(1);
    [y2, x2]=ginput(1);
    % Round indicies
    x1=uint8(x1);
    y1=uint8(y1);
    x2=uint8(x2);
    y2=uint8(y2);
    % Error check if choose color that already chose
    for k=1:length(clicked)
       if all([x1 y1]==clicked(k).point1) || all([x1 y1]==clicked(k).point2)||all([x2 y2]==clicked(k).point1) || all([x2 y2]==clicked(k).point2)
               set([axgameh, baraxesh,outbarh], 'Visible', 'off');
               colormap(ones(9,3))
                i=9;
       end
    end
    % Check if chose a match
    if mat(x1,y1)==mat(x2,y2) && ~all([x1 y1]==[x2 y2]) && i~=9  % If chose correct display points
       points=totalpoints(:,1:count);
       outbarh=bar(points,'parent', baraxesh, 'visible', 'off','barlayout', 'stacked');
       axis(baraxesh,[0 2 0 8])
       set([baraxesh, outbarh], 'visible', 'on')
       % Set correct match to green
       colormap(colorcorrect)
       mat(x1,y1)=9;
       mat(x2,y2)=9;
       image(mat,'parent',axgameh) 
       set(axgameh,'xtick',[0.5:1:8.5],'ytick', [0.5:1:8.5], 'xgrid', 'on','ygrid', 'on');
       % Store already chosen matches in structure
       clicked(j)=struct('point1',[x1 y1],'point2',[x2 y2]);
       % Show remaining pairs for 1 second
       colormap(colorcorrect2)
       image(mat,'parent',axgameh)
       pause(1)
       colormap(colorcorrect)
       image(mat,'parent',axgameh)
       set(axgameh,'xtick',[0.5:1:8.5],'ytick', [0.5:1:8.5], 'xgrid', 'on','ygrid', 'on');
       count=count+1;
    elseif i~=9 % If chose wrong match
       points=totalpoints(:,1:count);
       outbarh=bar(points,'parent', baraxesh, 'visible', 'off', 'barlayout','stacked');
       axis(baraxesh,[0 2 0 8])
       set([baraxesh,outbarh], 'visible', 'on')
       % Show remaining pairs
       colormap(colorcorrect2)
       image(mat,'parent',axgameh)
       pause(1)
       colormap(colorcorrect)
       image(mat,'parent',axgameh)
       set(axgameh,'xtick',[0.5:1:8.5],'ytick', [0.5:1:8.5], 'xgrid', 'on','ygrid', 'on');
    end
    i=i+1;    
end
% Setting up the last screen for the scoreboard:
set([outbarh, baraxesh, axgameh], 'visible', 'off');
colormap(ones(9,3))
set(f, 'color', 'white')
% Overall score
score=sum(sum(points));
% Get name the user enters and displays in the scoreboard
% If struture storing scores and names is empty, set to default
	name=get(nameh,'string');
	[first, last]=strtok(name);        
	if isempty(first) % If user does not enter name
    	cname=congrats(score);
        scorename{noplayed}= 'J. Doe';
	elseif isempty(last) % If user enters only first name
    	cname=congrats(score,first);
        scorename{noplayed}=name;
    else % If user enters first and last name
    	cname=congrats(score,first,last);
        scorename{noplayed}=name;
    end

% Store the score in the structure
scoreboard{noplayed}=score;
% Sort scoreboard from highest score
[scoreboard, ind]=sort(cell2mat(scoreboard), 'descend');
scoreboard={scoreboard};
scorename={scorename{ind}};
% Creat an anonymous function to print the highest score
printhigh=@(high) sprintf('The highest score is %d',high);
% Find the highest score
high=max(cell2mat(scoreboard));
scoretableh=uitable('parent' ,f,'units','normalized','position',[.2,.3,.6,.5], 'data', cell2mat(scoreboard)');
set(scoretableh,'rowname', scorename ,'columnname',{'Score'}, 'columneditable',[false false],...
    'columnwidth', {550});
statscoreh=uicontrol('parent', f,'style', 'text', 'units', 'normalized', 'position', [.2 .2 .6 .1],...
    'string',printhigh(high));
playagainh=uicontrol('parent', f,'style', 'pushbutton', 'units', 'normalized', ...
    'position', [.35 .1 .3 .1],'backgroundcolor', [0 .7 0.7],'string', 'Play Again', 'callback', @fnplayagain);
% Display the players name
congratsboxh=uicontrol('parent', f,'style','text','units','normalized','position',[.2,.8,.6,.1],'string',cname);

function fnplayagain(~,~)
    axhan=axes('parent',f,'units','normalized','position',[.15,.7,.777,.111]);
    axhanimg=image(imread('Titlefinal.jpg'));
    set([scoretableh,statscoreh,playagainh,congratsboxh], 'visible', 'off')
    set([playh, howh, smalltexth,nameh, axhan, axhanimg], 'visible', 'on')
end
end
end

function out=congrats(score,varargin)
if nargin==1
	out=sprintf('Congratulations! You got %d points', score);
elseif nargin==2
	out=sprintf('Congratulations, %s! You got %d points', varargin{1},score);
else
	out=sprintf('Congratulations, %s %s! You got %d points', varargin{1}, varargin{2},score);
end
end
