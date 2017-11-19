% Group 1
% Brian McIlwain, Justin Guillory, Marshall Simien, Mike Cole, Taj Chauvin
% Project 2

% LMS

recordSelection = recordDialog();

%if the user wants to record
if recordSelection == 1
    recObjSK = record(44100, 16, 5, 'Recording s(k)');
    s = getaudiodata(recObjSK);
    play(recObjSK);
    pause(5);
    recObjVK = record(44100, 16, 5, 'Recording v(k)');
    v = getaudiodata(recObjVK);
    i = size(v);
    play(recObjVK);
    answer = recordParameters();
    alpha = answer{1,1};
    alpha = eval(alpha);
    e_limit = answer{2,1};
    e_limit = eval(e_limit);
    epoc_limit = answer{3,1};
    epoc_limit = eval(epoc_limit);
else
    answer = parameterDialog();
    SK = answer{1,1};
    VK = answer{2,1};
    MK = answer{3,1};
    alpha = answer{4,1};
    alpha = eval(alpha);
    e_limit = answer{5,1};
    e_limit = eval(e_limit);
    epoc_limit = answer{6,1};
    epoc_limit = eval(epoc_limit);
    i = eval(answer{7,1}); %time
    s=zeros(i,1); % pure input signal
    v=zeros(i,1); % raw input noise near noise source
    m=zeros(i,1); % percieved noise near input signal
end

v_kMinus1 = v;
W=[0 0]; % Initial weights

for k = 1:i
    if recordSelection ~= 1
        s(k) = eval(SK);
        v(k) = eval(VK);
        m(k) = eval(MK);
    end
    
    if (k > 1)
        v_kMinus1(k) = v(k-1);
    end
end

diaryName = 'outputProj2.out';
diary(diaryName);
diary on;

for k=1:epoc_limit
    % Run lms algorythm
    [ W, e, r, X, Y] = lms( v, s, m, alpha, W);
    
    % Compute error
    error = norm(e);
    
    % If error under error limit terminate epocs
    if (error < e_limit)
        break;
    end
end

W
plot_lms(v, v_kMinus1, s, m, alpha, e, r, X, Y);

if recordSelection == 1
    figure;
    i = linspace(0, 5, 44100*5);
    title('Audio Recording');
        btn = uicontrol('Style', 'pushbutton', 'String', 'Play',...
            'Position', [20 20 50 20],...
            'Callback', 'play(recObj)');
    soundVect = getaudiodata(recObj); 
    plot(soundVect);
end

% Get output for display
diary off;
output=fileread(diaryName);
% Gui to show output to user
S.fh = figure('units','pixels',...
              'position',[100 100 400 400],...
              'menubar','none',...
              'resize','on',...
              'numbertitle','off',...
              'name','Program output');
S.tx = uicontrol('style','edit',...
                 'units','pix',...
                 'position',[10 10 380 380],...
                 'backgroundcolor','w',...
                 'HorizontalAlign','left',...
                 'min',5,'max',10,...
                 'enable','inactive');

% Display the output
set(S.tx,'string',cat(1,get(S.tx,'string'),{output}))
delete(diaryName); % cleanup