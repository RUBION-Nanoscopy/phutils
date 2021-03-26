classdef LorentzPSF < phutils.data.PSFData
    
    methods (Access = protected)
        
        function t = get_title( self )
            t = sprintf('Lorentz, FWHM=%g µm (%g×%g@%g×%g)', self.FWHM, self.XSize, self.YSize, self.XPx, self.YPx);
        end
        
        function d = fnc(~, x,y,cx,cy,fwhmx,fwhmy)
                
            d = (...
                  1/( (x-cx).^2 + (fwhmx/2).^2 ) ...
               .* 1/( (y-cy).^2 + (fwhmy/2).^2 ) ...
            );
        end
    end
end