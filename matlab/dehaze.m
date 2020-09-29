Iper=imread('/MATLAB Drive/00.png');
Ipar=imread('/MATLAB Drive/90.png');

N=255*255;
Ipar=double(Ipar(1:237,:,:))/N;Iper=double(Iper)/N;
Itotal=Ipar+Iper;

[m,n,o]=size(Ipar);

%[Ipar_infi,rect1]=imcrop(Ipar);
%Iper_infi=imcrop(Iper,rect1);
Ipar_infi=Ipar;
Iper_infi=Iper;

Pr=(sum(sum(Iper_infi(:,:,1)))-sum(sum(Ipar_infi(:,:,1))))/(sum(sum(Iper_infi(:,:,1)))+sum(sum(Ipar_infi(:,:,1))));
Pg=(sum(sum(Iper_infi(:,:,2)))-sum(sum(Ipar_infi(:,:,2))))/(sum(sum(Iper_infi(:,:,2)))+sum(sum(Ipar_infi(:,:,2))));
Pb=(sum(sum(Iper_infi(:,:,3)))-sum(sum(Ipar_infi(:,:,3))))/(sum(sum(Iper_infi(:,:,3)))+sum(sum(Ipar_infi(:,:,3))));

P=zeros(1,3);P(1)=Pr;P(2)=Pg;P(3)=Pb;
A=zeros(m,n,o);R=zeros(m,n,o);
for k=1:3
    A(:,:,k)=(Iper(:,:,k)-Ipar(:,:,k))/P(k);
end

x=A(:,:,1);y=A(:,:,2);z=A(:,:,3);

Ainf=zeros(1,3);
[m1,n1,o1]=size(Ipar_infi);
Ainfr=(sum(sum(Iper_infi(:,:,1)))+sum(sum(Ipar_infi(:,:,1))))/(m1*n1);
Ainfg=(sum(sum(Iper_infi(:,:,2)))+sum(sum(Ipar_infi(:,:,2))))/(m1*n1);
Ainfb=(sum(sum(Iper_infi(:,:,3)))+sum(sum(Ipar_infi(:,:,3))))/(m1*n1);

Ainf(1)=Ainfr;Ainf(2)=Ainfg;Ainf(3)=Ainfb;

t=zeros(m,n,o);
for k=1:3
    t(:,:,k)=max(1-(A(:,:,k)/Ainf(k)),0.1);
end

r=60;eps=10^-6;
%for k=1:3
%    t(:,:,k)=guided_filter(Itotal,t(:,:,k),r,eps);
%end
t=guided_filter(Itotal,t,r,eps);

for k=1:3
    R(:,:,k)=(Itotal(:,:,k)-A(:,:,k))./(t(:,:,k));
end

imshow(R);
imwrite(R,'/MATLAB Drive/R.png');