function vtc = vtc_apply_bbx(f, d, vtcfilename,bbx,overwrite)
% applies bbx to vtc and outputs truncated vtc file
% bbx =  3 * 2 matrix, X Y and Z limits
if nargin==0
    
    [f, d]= uigetfile('*.vtc');
    vtcfilename = [d f];
    overwrite = 1;
end

disp(['Loading ' vtcfilename '...']);
vtc = xff(vtcfilename);

XS = bbx(1,1) - vtc.XStart;
XE = bbx(1,2) - bbx(1,1) + 1;
YS = bbx(2,1) - vtc.YStart;
YE = bbx(2,2) - bbx(2,1) + 1;
ZS = bbx(3,1) - vtc.ZStart;
ZE = bbx(3,2) - bbx(3,1) + 1;

disp('Truncating vtc file...');
vtc.VTCData(:,1:XS,:,:) = [];
vtc.VTCData(:,XE:end,:,:) = [];

vtc.VTCData(:,:,1:YS,:) = [];
vtc.VTCData(:,:,YE:end,:) = [];

vtc.VTCData(:,:,:,1:ZS) = [];
vtc.VTCData(:,:,:,ZE:end) = [];

vtc.XStart = bbx(1,1);
vtc.XEnd = bbx(1,2);
vtc.YStart = bbx(2,1);
vtc.YEnd= bbx(2,2);
vtc.ZStart = bbx(3,1);
vtc.ZEnd = bbx(3,2);


if overwrite
    disp('Overwriting file to disk...');
    vtc.SaveAs(vtcfilename);
else
    disp('Saving file to disk...');
    vtc.SaveAs([d strrep(f,'.vtc','_bbox_adj.vtc')]);
end

