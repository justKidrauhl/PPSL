% clear ;
% close all;
currentpath = cd ;
AddedPath = genpath( currentpath ) ;
addpath( AddedPath ) ;
% fprintf('\n\n**************************************   %s   *************************************\n' , datestr(now) );
% fprintf( [ mfilename(currentpath) ' Begins.\n' ] ) ;
% fprintf( [ mfilename(currentpath) ' is going, please wait...\n' ] ) ;

%% ��������ѡ��
Data = 'Yale' ;                                 % Yale����,15�࣬ÿ��11����������165������
% Data = 'ORL' ;                                  % ORL���ݣ�40�࣬ÿ��10����������400������
% Data = 'UMIST' ;                                % UMIST���ݣ�20�࣬ÿ��Լ29����������575������
% Data = 'YaleB' ;                                % YaleB���ݣ�38�࣬ÿ��Լ64������
% Data = 'YaleB10' ;                              % YaleB10���ݣ���YaleB�г�ȡǰ10���������10�࣬ÿ��Լ64������
% Data = 'AR' ;                                   % AR���ݣ�100�࣬ÿ��14������

%% ��ά����ѡ��
% FeatureExtractionMethod = 'PCA' ;
% FeatureExtractionMethod = 'OP_SRC' ; % 'SRC_DP' ;   %
% FeatureExtractionMethod = 'Nothing';
% FeatureExtractionMethod = 'OP_LRC' ;
% FeatureExtractionMethod = 'XPDR';
% FeatureExtractionMethod = 'GaborPCA';
FeatureExtractionMethod   = 'LDA' ;
% FeatureExtractionMethod = 'MMC' ;
% FeatureExtractionMethod = 'Random' ;
% FeatureExtractionMethod = 'OP_NFS' ;
% FeatureExtractionMethod = 'Identity' ;
% FeatureExtractionMethod = 'LPP' ;   % û��ͨ
% FeatureExtractionMethod = 'LRPP' ;
% FeatureExtractionMethod = 'SLRPP' ;
% FeatureExtractionMethod = 'SPP' ;
% FeatureExtractionMethod = 'MaxSubAngel' ;



%% Feature Filter
% LinearFilterType         = '2D-GaborFilter';
% LinearFilterType         = 'SobelFilter';
% LinearFilterType          = 'Gabor40';
% LinearFilterType         = 'Nothing';
LinearFilterType = 'Gabor40_real';

%% ������ѡ��
% Classifier              = 'SRC_lu_SPAMS' ;
% Classifier              = 'KLRC' ;
% Classifier              = 'SingularFeature' ;
% Classifier              = 'WSRC_SPAMS' ;
Classifier                = 'kNN' ;
% Classifier              = 'NFS' ;
% Classifier              = 'NFS_gui' ;
% Classifier              = 'SRC_lu' ;
% Classifier              = 'SRC_QC1' ;
% Classifier              = 'SRCe' ;
% Classifier              = 'OrthonormalL2' ;
% Classifier              = 'LRRC' ;
% Classifier              = 'DiffSingular' ;
% Classifier              = 'WLRC' ;


%% Random splits
splits = 10;

%% ��ά����ά������
switch Data
    case 'Yale'
        % Yale data,15 classes, 11samples per class
        Train = 5 : 5 ;                         % ÿ����ѵ���������������ڲ�ͬ��Trainά��Ҫ�ı䣬���������ʱ���ʺ϶�Train�����ı䡣
        D = [1024];
        %D = [10 30 50 60 70 74 ] ;
        %        D = [ 1: 74 ] ;                % PCA��6Trainʱ���ά89
        %         D = [ 5 10 15 20 25 30 40 50  60 70 80 85 89] ;                % PCA��6Trainʱ���ά89
        %         D = 60 ;
        %         D = [50 100 200 300 500 700 1000] ;
        if strcmp( FeatureExtractionMethod , 'LDA' )
            D = [ 3 5 7 9 11 13 14 ] ;                        % LDA�����ά14
            %             D = 14 ;
        end
        if strcmp( FeatureExtractionMethod , 'Nothing' )
            D = [1024];
        end
    case 'ORL'
        % ORL���ݣ�40�࣬ÿ��10������
        Train = 4 : 4 ;                         % ÿ����ѵ����������
        D = [ 10 30 50 80 120 150 180 195] ;              % PCA��5Trainʱ���ά199
        %         D = 5 : 5 : 199
        %         D = [ 120 140 160 180 199] ;              % PCA��5Trainʱ���ά199
        D = 1:159 ;
        if strcmp( FeatureExtractionMethod , 'LDA' )
            D = [ 5 10 20 25 30 35 39] ;                        % LDA�����ά39
        end
    case 'UMIST'
        % UMIST���ݣ�20�࣬ÿ��Լ29����������575������
        Train = 12 : 12 ;                         % ÿ����ѵ����������
        D = [ 30 60 80 100 110 ] ;              % PCA��6Trainʱ���ά119
        %         D = [ 120 140 160 180 199] ;
        %         D = 5 : 5 : 237 ;
        if strcmp( FeatureExtractionMethod , 'LDA' )
            D = [ 5:5:19] ;                        % LDA�����ά39
        end
        
    case 'YaleB'
        % YaleB���ݣ�38�࣬ÿ��Լ64������
        Train = 40 : 40 ;                       % ÿ����ѵ����������
        D = [100 200 500 900] ;%
        % PCA��30Trainʱ���ά1024
        %D = [ 30 56 ] ; %���Դ�20��ʼ�ͺ�
        if strcmp( FeatureExtractionMethod , 'LDA' )
            %             D = [ 5 10 15 30 35 37] ;
            D = [ 5:5:37 ] ;                        % LDA�����ά37
            %             D = 1 : 37 ;
        end
    case 'YaleB10'
        % YaleB10���ݣ�YaleB���ݵ�ǰ10�࣬10�࣬ÿ��Լ64������
        Train = 30 : 30 ;                       % ÿ����ѵ����������
        D = [ 50 ] ;
        %
        % PCA��30Trainʱ���ά1024
        %         D = 20:5:120 ; %���Դ�20��ʼ�ͺ�
        if strcmp( FeatureExtractionMethod , 'LDA' )
            D = [ 7 8 9] ;
            %             D = [ 5:5:37 ] ;                        % LDA�����ά37
        end
    case 'AR'
        % AR���ݣ�100�࣬ÿ��14������
        Train = 7 : 7 ;                         % ÿ����ѵ����������
        D = [ 30 54 130 540] ;                  % PCA��7Trainʱ���ά699
        D = [ 30 54  ] ;
        if strcmp( FeatureExtractionMethod , 'LDA' )
            %             D = [ 30 56 99] ;                   % LDA�����ά99
            D = [ 10 20 30 40 50 60 70 80 90] ;
        end
end
length_D = length(D) ;

%% ������
% ResultsTxt = [ '.\Results\' Data '\' num2str(Train) 'Train_' Classifier '_' FeatureExtractionMethod '_D=[' num2str(D) ']_s=' num2str(splits) '.txt' ] ;
% fid = fopen( ResultsTxt , 'wt' ) ;              % ���������ı��ļ�
fid = 1 ;                                       % ����������Ļ
fprintf( fid , '\n\n**************************************   %s   *************************************\n' , datestr(now) );
fprintf( fid , ['Function                   = ' mfilename(currentpath) '.m\n' ] ) ;
fprintf( fid ,  'Data                       = %s\n' , Data ) ;
fprintf( fid ,  'FeatureExtractionMethod    = %s\n' , FeatureExtractionMethod ) ;
fprintf( fid ,  'Classifier                 = %s\n' , Classifier ) ;
fprintf( fid ,  'splits                     = %d\n\n' , splits ) ;

%% ���ݵ��롢��һ��
path_data = ['.\Data\' Data '\' ] ;
load( [path_data , Data] ) ;
for i = 1 : size(fea,2)
    fea(:,i) = fea(:,i) / norm( fea(:,i) ) ;
end

%% ��ά�����ࡢ������
for ii = 1: length( Train )
    i = Train( ii ) ;                           % i��ÿ����ѵ����������
    fprintf( fid , 'Train_%d : \n' , i ) ;
    if strcmp( FeatureExtractionMethod , 'XPDR' )
        Accuracy = size(splits, 1);
    else
        Accuracy = size( splits , length_D ) ;
    end
    load( [path_data 'idxData' num2str(i)] ) ;
    for s = 1 : splits                          % �Բ�ͬ�ķָ�
        % ��Ϊѵ�������Ͳ�������
        
        fea_Train = fea( : , idxTrain(s,:) ) ;
        gnd_Train = gnd( idxTrain(s,:) ) ;
        fea_Test = fea( : , idxTest(s,:) ) ;
        gnd_Test = gnd( idxTest(s,:) ) ;
        [fea_Train,gnd_Train,fea_Test,gnd_Test] = Arrange(fea_Train,gnd_Train,fea_Test,gnd_Test) ;
        
        %%Reconstruction Methods
        % ReconstructionMethod     = 'Nothing';
        % ReconstructionMethod     = 'PCA';
        % ReconstructionMethod     = 'XPDR';
         ReconstructionMethod     = 'ALM_XPDR';
        %ReconstructionMethod     = 'APG_XPDR';
        
        DoRec =1;
        
        if DoRec == 1,
            % Get the Reconstructed Image
            ReducedDim = 60;
            % 0 means use full-rank;
            tic;
            [ProjectionMatrix, Rec_fea_Train, ReducedDim] = Reconstruction(ReconstructionMethod, fea_Train, ReducedDim);
            reconstructiontime = toc;
            time = num2str(reconstructiontime);
            [time1, time2] = strtok(time,'.');
            time2 = time2(2:end);
            %[fea_Train, ReducedDim] = Reconstruction(ReconstructionMethod, fea_Train, ReducedDim);
            
            %             ResultsMat = [ '.\Features\fea_Train' num2str(i) 'Train_' Data '_' ReconstructionMethod '_ReducedDim=' num2str(ReducedDim) '_s=' num2str(splits) ] ; % '_D=[' num2str(D) ']_s=' '
            %             disp(ResultsMat);
            %             save( ResultsMat , 'Rec_fea_Train','ReducedDim' ) ;
            ResultsMat = [ '.\Features\' datestr(now,30) '_fea_Train' num2str(i) 'Train_' Data '_' ReconstructionMethod '_ReducedDim=' num2str(ReducedDim) '_s=' num2str(s) '_time=' time1 '_' time2 '_ProjectionMatrix' ] ; % '_D=[' num2str(D) ']_s=' 'save( ResultsMat , 'ProjectionMatrix' ) ;
            
            %Compress the test image:
            %nSmp = size(fea_Test, 2);
            %mean_fea_Test = repmat(mean(fea_Test, 2), 1, nSmp);
            %Rec_fea_Test =mean_fea_Test + ProjectionMatrix * (fea_Test-mean_fea_Test);
            Rec_fea_Test = ProjectionMatrix * fea_Test;
            
            % Feature Extraction with Linear Filter
            disp('filtering!');
            %Filtered_fea_Train = fea_Train;
            [Filtered_fea_Train] = LinearFilter(LinearFilterType, fea_Train);
            disp('Train filtered!');
            %Filtered_fea_Test = Rec_fea_Test;
            [Filtered_fea_Test] = LinearFilter(LinearFilterType, Rec_fea_Test);
            disp('Test filtered!');
            
        elseif DoRec == 0,
            Rec_fea_Test = fea_Test;
            
            disp('filtering!');
            %Filtered_fea_Train = fea_Train;
            [Filtered_fea_Train] = LinearFilter(LinearFilterType, fea_Train);
            disp('Train filtered!');
            %Filtered_fea_Test = Rec_fea_Test;
            [Filtered_fea_Test] = LinearFilter(LinearFilterType, Rec_fea_Test);
            disp('Test filtered!');
            
            if strcmp(FeatureExtractionMethod, 'Nothing')
                D = [size(Filtered_fea_Train, 1)];
            end
            
            
        else
            Garborsetno = 8;
            
            Rec_fea_Test = [];
            disp('filtering!');
            %Filtered_fea_Train = fea_Train;
            [Filtered_fea_Train] = LinearFilter(LinearFilterType, fea_Train);
            Filtered_fea_Train = Filtered_fea_Train(1:Garborsetno*1024,:);
            disp('Train filtered!');
            D = [Garborsetno*1024]; %To make the train and test have the same dimension
            
            Filtered_fea_Test = [];
            for p = 1:Garborsetno,
                ResultsMat = [ '.\40Garbor\fea_Train' num2str(i) 'Train_' Data '_' ReconstructionMethod '_s=' num2str(s) 'ProjectionMatrix' num2str(p) ] ; % '_D=[' num2str(D) ']_s=' '
                load(ResultsMat);
                temp = ProjectionMatrix * fea_Test;
                Showimage(temp, [32,32], [9,10]);
                [Filtered_temp_Test] = LinearFilter_separate(LinearFilterType, temp, p);
                Filtered_fea_Test = [Filtered_fea_Test; Filtered_temp_Test];
                disp('Test filtered!');
            end;
        end;
        
        
        
        
        % ��ά
        DoFeatureExtraction = 1;
        
        if DoFeatureExtraction == 1,
            [ Yfea_Train , Yfea_Test redDim] = FeatureExtraction( FeatureExtractionMethod , Filtered_fea_Train , gnd_Train , Filtered_fea_Test ) ;
        else
            Yfea_Train = Filtered_fea_Train;
            Yfea_Test = Filtered_fea_Test;
        end;
        
        %         save ARRandProj6 Yfea_Train Yfea_Test
        %         load ARRandProj6
        % ����
        
        
        %if strcmp( ReconstructionMethod , 'PCA' ),
        %        Accuracy(s) = eval( [ Classifier '( fea_Train , gnd_Train , fea_Test , gnd_Test )' ] ) ;
        %elseif strcmp( ReconstructionMethod , 'ALM_XPDR' ),
        %    Accuracy(s) = eval( [ Classifier '( fea_Train , gnd_Train , fea_Test , gnd_Test )' ] ) ;
        %else
        for dd = 1 : length_D
            d = D(dd) ;
            tic
            Accuracy(s,dd) = eval( [ Classifier '( Yfea_Train(1:d,:) , gnd_Train , Yfea_Test(1:d,:) , gnd_Test )' ] ) ;
            toc
            %             fprintf('********************************************************************\n') ;
            %             fprintf('dim = %d %f\n', d , Accuracy(s,dd) ) ;
        end
        % end
    end
    
    ave_Acc = mean( Accuracy , 1 ) ;
    [max_Acc,dd] = max( ave_Acc ) ;
    max_Dim = D( dd ) ;
    std_Acc = std( Accuracy(:,dd) ) ;
    
    fprintf( fid , 'Dim =\t\t' ) ;
    for dd = 1 : length_D
        fprintf( fid , '\t%5d' , D(dd) ) ;
    end
    fprintf( fid , '\n' ) ;
    for s = 1 : splits
        fprintf( fid, 's = %2d\t%8s' , s , FeatureExtractionMethod ) ;
        for dd = 1 : length_D
            d = D(dd) ;
            fprintf( fid , '\t%.2f ' , Accuracy(s,dd)*100 ) ;
        end
        fprintf( fid , '\n' ) ;
    end
    fprintf( fid , 'ave_Acc %8s ' , FeatureExtractionMethod ) ;
    for dd = 1 : length_D
        d = D(dd) ;
        fprintf( fid , '\t%.2f ' , ave_Acc(dd)*100 ) ;
    end
    fprintf( fid , '\n' ) ;
    fprintf( fid , '%dTrain max_Acc��std_Acc = %.2f��%.2f , max_Dim = %d\n' , i , max_Acc*100 , std_Acc*100 , max_Dim  ) ;
    fprintf( fid , '%dTrain data is done!\n',i) ;
    
    %% ��������MAT�ļ�
    %     ResultsMat = [ '.\Results\' Data '\' num2str(i) 'Train_' Classifier '_' FeatureExtractionMethod '_D=[1-74]_s=' num2str(splits) ] ; % '_D=[' num2str(D) ']_s='     _D=[1-89]_s=
    %     ResultsMat = [ '.\Results\' Data '\' num2str(i) 'Train_' Classifier '_' FeatureExtractionMethod '_D=[' num2str(D) ']_s=' num2str(splits) ] ; % '_D=[' num2str(D) ']_s='
    %     save( ResultsMat , 'Data' , 'Train' , 'splits' , 'D' , 'FeatureExtractionMethod' , 'Classifier' , 'Accuracy' , 'ave_Acc' , 'max_Acc' , 'max_Dim' , 'std_Acc' ) ;
end


% load E:\Work\LRRC\Results\YaleB\30Train_SRC_lu_SPAMS_PCA_D=[70-89]_s=1  % YaleB
% load 6Train_SRC_lu_SPAMS_PCA_D=[70-89]_s=1    % Yale


% plot(D,ave_Acc,'b')
% hold on
% load E:\Work\LRRC\Results\YaleB\30Train_KLRC_PCA_D=[70-89]_s=1  % YaleB
%
% % load 6Train_KLRC_PCA_D=[70-89]_s=1
% plot(D,ave_Acc,'r')
% legend('SRC','KLRC')
% hold off



fprintf('\n') ;
if fid ~= 1
    fclose(fid) ;
end
fprintf( [ mfilename(currentpath) ' is done!\n' ] ) ;
% rmpath( AddedPath ) ;