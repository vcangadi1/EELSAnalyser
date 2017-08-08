
function result = RL_deconv(image, PSF, iterations)
    % to utilise the conv2 function we must make sure the inputs are double
    image = double(image);
    PSF = double(PSF);
    latent_est = image; % initial estimate, or 0.5*ones(size(image)); 
    PSF_HAT = PSF(end:-1:1,end:-1:1); % spatially reversed psf
    % iterate towards ML estimate for the latent image
    for i= 1:iterations
        est_conv      = conv2(latent_est,PSF,'same');
        relative_blur = image./est_conv;
        error_est     = conv2(relative_blur,PSF_HAT,'same'); 
        latent_est    = latent_est.* error_est;
        fprintf('%d\n',i);
    end
    result = latent_est;
%}
%{
function result = RL_deconv(image, PSF, iterations)
fn = image; % at the first iteration
OTF = psf2otf(PSF,size(image)); 
for i=1:iterations
    ffn = fft2(fn); 
    Hfn = OTF.*ffn; 
    iHfn = ifft2(Hfn); 
    ratio = image./iHfn;
    iratio = fft2(ratio);
    res = OTF .* iratio; 
    ires = ifft2(res); 
    fn = ires.*fn; 
end
result = abs(fn); 
%}
%{
    function latent_est = RL_deconv(observed, psf, iterations)
    % to utilise the conv2 function we must make sure the inputs are double
    observed = double(observed);
    psf      = double(psf);
    % initial estimate is arbitrary - uniform 50% grey works fine
    latent_est = 0.5*ones(size(observed));
    % create an inverse psf
    psf_hat = psf(end:-1:1,end:-1:1);
    % iterate towards ML estimate for the latent image
    for i= 1:iterations
        est_conv      = conv2(latent_est,psf,'same');
        relative_blur = observed./est_conv;
        error_est     = conv2(relative_blur,psf_hat,'same'); 
        latent_est    = latent_est.* error_est;
    end
%}