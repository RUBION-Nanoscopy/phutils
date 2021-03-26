classdef GaussPSF < phutils.data.PSFData
    
    methods (Access = protected)
        
        function t = get_title( self )
            t = sprintf('Gauss, FWHM=%g µm (%g×%g@%g×%g)', self.FWHM, self.XSize, self.YSize, self.XPx, self.YPx);
        end
        
        function d = fnc(~, x,y,cx,cy,fwhmx,fwhmy)
            sigmax = fwhm2sigma(fwhmx);
            sigmay = fwhm2sigma(fwhmy);
            d = exp(-1.* ...
                ( ...
                   ( ( (x-cx).^2 ) ./ (2 .* sigmax.^2 ) ) ...
                 + ( ( (y-cy).^2 ) ./ (2 .* sigmay.^2 ) ) ...
                ) ...
            );
        end
    end
end