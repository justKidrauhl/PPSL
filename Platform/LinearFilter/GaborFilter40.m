function GaborFeature = GaborFilter40(Image,knSize)

%��ͼ����ȡ��Gabor����,�ô�matlabʵ�֡�
% Input��
%       Image: ��ά���󣬻Ҷ�ֵ
%
% Output:
%       GaborFeature����ȡ�������Gabor������Ϊ��R��C��40��������
%
%Notes:
%       40��Gabor���˲�����˳�����ȷ����߶�.


% * ��ǰ�汾��1.0
% * ��    �ߣ�ţ־�㣬����
% * ������ڣ�2008��4��11��


imgSize = size(Image);
if length(imgSize)~=2
    err('ֻ�ܴ���Ҷ�ͼ��');
end
if isa(Image,'double')~=1 
    Image = double(Image);
end
%knSize = [65 65];
gkSize = [ 5 8];
if any(knSize>imgSize)
    error('Gabor kernel is larger than image!');
end
glGaborKernel = {};
GaborFeature = zeros([imgSize gkSize(1)*gkSize(2)]);
if isempty(glGaborKernel) ||  any(size(glGaborKernel{1,1})~= imgSize)
    glGaborKernel = funSetKernel(knSize(1),knSize(2),gkSize(1),gkSize(2),2*pi,2*pi,pi/2,sqrt(2));
    fftw('planner','patient');
    for j = 1:gkSize(1)
        for k = 1:gkSize(2)
            imgKernel = glGaborKernel{j,k};
            imgKernel(imgSize(1),imgSize(2)) = 0;
            imgKernel = circshift(imgKernel,ceil((imgSize-knSize)/2));
            imgKernel = fftshift(imgKernel);
            glGaborKernel{j,k} = fftn(imgKernel);
        end
    end
end
%tic
imgFFT = fftn(Image);
for j = 1:gkSize(1)
    for k = 1:gkSize(2)
        Out = imgFFT.*glGaborKernel{j,k} ;
        Out = ifftn(Out);
        GaborFeature(:,:,(j-1)*gkSize(2)+k) = Out;
    end
end
%t = toc;
%disp(t);

function GaborKernel = funSetKernel(KernelWidth, KernelHeight, scale, nOrientation,  xSigma,  ySigma, Kmax,  Frequency)

GaborKernel = cell(scale,nOrientation);
X = -(KernelWidth -1)/2:(KernelWidth -1)/2;
Y = -(KernelHeight-1)/2:(KernelHeight-1)/2;
[Y,X] = meshgrid(X,Y);
for j = 1:nOrientation
    Phi = (j-1) * pi / nOrientation;
    for k = 1:scale
        Kv  = Kmax / Frequency^(k-1);
        Kuv = Kv^2;
        xySigma = xSigma*ySigma;
        Mag = exp(-Kuv*((X/xSigma).^2 + (Y/ySigma).^2))*Kuv/xySigma;
        Pha = Kv*(cos(Phi)*X + sin(Phi)*Y);
        GaborKernel{k,j} = Mag.*(exp(i*Pha)-exp(-xySigma/2));
    end
end
