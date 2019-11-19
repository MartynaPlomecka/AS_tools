%now with eye electrodes BUT WITHOUT UNFOLD. THIS FILE IS JUST FOR ME, FOR
%GENERATING NEW PLOTS FOR MEETING WITH CHRISTAIN
clear all
addpath('/Users/mplome/Desktop/eeglab14_1_2b')
addpath('tools');
addpath('/Users/mplome/Desktop/PawelTools')
eeglab
close
table_old = readtable("/Users/mplome/Downloads/old.xlsx");
table_young =readtable("/Users/mplome/Downloads/young.xlsx");
oldIDsA = table_old{3:end,1};
oldIDsB= table_old{3:end,2};
all_oldIDs = [oldIDsA; oldIDsB];
youngIDsA = table_young{3:end,1};
youngIDsB= table_young{3:end,2};
all_youngIDs = [youngIDsA; youngIDsB];

%tak bylo w starrym
%raw= '/Users/mplome/Desktop/HOPE/EEG_prep_ica_blocks_1_results'; % path to preprocessed eeg files
%etfolder='/Users/mplome/Desktop/HOPE/ET'; %MO

raw= '/Users/mplome/Desktop/balanced/EEG_preprocessed'; % path to preprocessed eeg files
etfolder='/Users/mplome/Desktop/balanced/ET'; %MO

d=dir(raw) %what folders are in there (each folder = one subject)

d(1:3)=[] % get rid of the . and .. folders as well as .DS_Store on mac

OLD_OR_YOUNG = {'old', 'yng'};
%data_pro_old = {};
%data_pro_yng = {};
data_pro_right_old = {};
data_pro_right_yng = {};
data_anti_left_old = {};
data_anti_left_yng = {};
data_pro_left_old = {};
data_pro_left_yng = {};
data_anti_right_old = {};
data_anti_right_yng = {};


% for loop to generate data
for i=1:length(d) %loop over all subjects
    if d(i).isdir
        subjectfolder=dir([d(i).folder filesep d(i).name  ]);
        
        deleteindex=[];
        for ii=1:length(subjectfolder)
            if not(endsWith(subjectfolder(ii).name, '_EEG.mat')) || startsWith(subjectfolder(ii).name,'bip') || startsWith(subjectfolder(ii).name,'red')
                deleteindex(end+1)=ii;
            end
        end
        subjectfolder(deleteindex)=[];
        FullEEG=[];
        for ii=1:length(subjectfolder)
            load ([subjectfolder(ii).folder filesep subjectfolder(ii).name]) % gets loaded as EEG
            fileindex=subjectfolder(ii).name(end-8) %here you need to find the index from thefile (end-someting) indexing
            etfile=  [etfolder filesep d(i).name filesep d(i).name '_AS' fileindex '_ET.mat'] %define string of the complete path to the matching ET file.
             
            EEG = pop_reref(EEG,[]) %tu jest wazna sprawa, to reref
            
            
            %merge ET into EEG
            ev1=94 %first trigger of eeg and ET file
            ev2=50 % end trigger in eeg and ET file
            EEG=pop_importeyetracker(EEG, etfile,[ev1 ev2], [1:4], {'TIME' 'L_GAZE_X' 'L_GAZE_Y' 'L_AREA'},1,1,0,0,4)
            %sprawdz pupil size, w razie czego zmien
            if ii==1
                FullEEG=EEG;
            else
                FullEEG=pop_mergeset(FullEEG,EEG);
            end
        end

        if isempty(FullEEG)
            continue
        end
        
%%

        FullEEG = InvalidateDistracted(FullEEG);
        
        
        countblocks = 0;
        previous = '';
        for e = 1:length(FullEEG.event)
            if contains (FullEEG.event(e).type,'94')
                countblocks = countblocks+1;
            end
            if countblocks == 2 || countblocks == 3 || countblocks == 4
                if contains (FullEEG.event(e).type,'10')
                    FullEEG.event(e).type = '12 ';
                elseif contains (FullEEG.event(e).type,'11')
                    FullEEG.event(e).type = '13 ';
               
                end
                if contains (FullEEG.event(e).type,'40') 
                    FullEEG.event(e).type = '41 ';
                end
            end

            if strcmp(FullEEG.event(e).type, 'L_saccade')
                if contains(previous, '10 ')
                    FullEEG.event(e).type = 'L_saccade_10';
                elseif contains(previous, '11 ')
                    FullEEG.event(e).type = 'L_saccade_11';
                elseif contains(previous, '12 ')
                    FullEEG.event(e).type = 'L_saccade_12';
                elseif contains(previous, '13 ')
                    FullEEG.event(e).type = 'L_saccade_13';
                end             
            end
            
            if ~strcmp(FullEEG.event(e).type, 'L_fixation') ...
                    && ~strcmp(FullEEG.event(e).type, 'L_blink')
                previous = FullEEG.event(e).type;
            end
        end
        
        
        id=d(i).name ;
        young=    any(contains(all_youngIDs,id));
        old =     any(contains(all_oldIDs,id));
        
   
        %young means 1, old means 0
        all_ages(i) =    young;
        all_eeg{i} = FullEEG;
        
%         FullEEG_noeye = FullEEG;
%         FullEEG_noeye.chanlocs = FullEEG.chanlocs(1:105);
%         FullEEG_noeye.data = FullEEG.data(1:105, :);
%         FullEEG_noeye.nbchan = 105;
        
%         [ufresult,EEG_res,EEG_model] = unfold_martyna(FullEEG_noeye);
        path = ['/Users/mplome/Desktop/UnfoldEEG/raw_no_unfold_age/' id];
        mkdir(path);
%         save([path '/ufresult.mat'], 'ufresult');
%         save([path '/rEEG.mat'], 'EEG_res');
%         save([path '/mEEG.mat'], 'EEG_model');

      
        try

            data_pro_right{i} = pop_epoch(FullEEG, {'11  '}, [-0.3,1]);
            data_pro_left{i} = pop_epoch(FullEEG, {'10  '}, [-0.3,1]);
            data_anti_right{i} = pop_epoch(FullEEG, {'13  '}, [-0.3,1]);
            data_anti_left{i} = pop_epoch(FullEEG, {'12  '}, [-0.3,1]);
            
            data_pro_right{i} =   pop_rmbase(data_pro_right{i},[-300,0]);
            data_pro_left{i} =   pop_rmbase(data_pro_left{i},[-300,0]);
            data_anti_right{i} =   pop_rmbase(data_anti_right{i},[-300,0]);
            data_anti_left{i} =   pop_rmbase(data_anti_left{i},[-300,0]);
            
            data_pro_right{i} = FilterByEventLatency(data_pro_right{i}, 'L_saccade_11', 100, 500);
            data_pro_left{i} = FilterByEventLatency(data_pro_left{i}, 'L_saccade_10', 100, 500);
            data_anti_right{i} = FilterByEventLatency(data_anti_right{i}, 'L_saccade_13', 100, 500);
            data_anti_left{i} = FilterByEventLatency(data_anti_left{i}, 'L_saccade_12', 100, 500);
            
            
            
            OLD_OR_YOUNG = {'old', 'yng'};

            eval(['data_pro_right_' OLD_OR_YOUNG{young+1} '{end+1} = data_pro_right{i}']);
            eval(['data_pro_left_' OLD_OR_YOUNG{young+1} '{end+1} = data_pro_left{i}'])
            eval(['data_anti_right_' OLD_OR_YOUNG{young+1} '{end+1} = data_anti_right{i}']);
            eval(['data_anti_left_' OLD_OR_YOUNG{young+1} '{end+1} = data_anti_left{i}']);
        

        catch
        end
    end
end
clear data_pro_right;
clear data_pro_left;
clear data_anti_left;
clear data_anti_right;

data_pro_right{1} = MergeSets(data_pro_right_yng{:})
data_pro_left{1} = MergeSets(data_pro_left_yng{:})
data_anti_right{1} = MergeSets(data_anti_right_yng{:})
data_anti_left{1} = MergeSets(data_anti_left_yng{:})
data_pro_right{2} = MergeSets(data_pro_right_old{:})
data_pro_left{2} = MergeSets(data_pro_left_old{:})
data_anti_right{2} = MergeSets(data_anti_right_old{:})
data_anti_left{2} = MergeSets(data_anti_left_old{:})
%%        
for si=1:length(data_anti_right)
    data_pro_right{si} = ClipToBounds(data_pro_right{si}, -100, 500);
    data_pro_left{si} = ClipToBounds(data_pro_left{si}, -500, 100);
    data_anti_right{si} = ClipToBounds(data_anti_right{si}, -500, 100);
    data_anti_left{si} = ClipToBounds(data_anti_left{si}, -100, 500);
    
    id=d(si).name;
    path = ['/Users/mplome/Desktop/UnfoldEEG/no_unfold/old_yng/o1/' num2str(si)];
    ITEMS = {
        {'ANTI right', data_anti_right{si}};
        {'ANTI left', data_anti_left{si}};
        {'PRO right', data_pro_right{si}};
        {'PRO left', data_pro_left{si}};
    };
%E75 = 62 = oz
%E70 = 58 =o1
%E83= 69 =o2
    ELECTRODE = 62;
    I_TITLE = 1;
    I_EEG = 2;

    timepoints=[135,150,170];

    figure
    if si == 1
        group = 'Young'
    else
        group = 'Old'
    end
    
    sgtitle([group ' raw no unfold SANITY CHECKS o1 electrode'])
    for I=1:length(ITEMS)
        erp = mean(ITEMS{I}{I_EEG}.data,3);
        times = ITEMS{I}{I_EEG}.times;
        
        % topoploty
        for i=1:3
            subplot(4,9,9*(I-1)+i)
            timepoint = timepoints(i);
            topoplot(erp(1:105,timepoint),EEG.chanlocs(1:105),'maplimits',[-3 3])
            %timepoint2sec(tp) = 2*tp - 200
            title (num2str((timepoint*2)-200))
        end
        
        %erp
        subplot(4,9,9*(I-1)+[4,5,6])
        %tu dodaje times
        plot(times(1:300), erp(ELECTRODE,1:300));
        hold on
        xline(0)
        title([ITEMS{I}{I_TITLE} ' ERP']);

       
        %imagesc
        subplot(4,9,9*(I-1)+[7,8,9])
        image_sc_data = squeeze(mean(ITEMS{I}{I_EEG}.data(1:105,:,:),3));
        imagesc(image_sc_data);
        xline(100)
        colorbar;
        caxis ([-5,5]);
    end
    mkdir(path);
    saveas(gcf,[path, '/figure.png']);
    
end