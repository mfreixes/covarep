% Get the winlen
% ... while adjusting it to the min f0 in the window
function winlen = get_optimal_winlen(f0s, fs, ind, opt)

    winf0 = f0s(ind,2); % the f0 corresponding to the window length
    prevf0 = Inf;
    while winf0<prevf0
        prevf0 = winf0;

        % Number of harmonic up to Nyquist
        Hm = floor((0.5*fs-0.5*winf0)/winf0);

        % Base length defined by the number of periods in the window
        winlen = round(opt.win_durnbper*fs/winf0);
        if opt.use_ls % If use LS solution, a minimum theoret length is required
            if ~opt.fquasiharm
                % In HM, 1 variable per harmonic on both pos and neg freq
                winlen = max(winlen,round(2*(1+opt.win_ls_marg)*Hm));
            else
                % In QHM, 2 variables per harmonic
                winlen = max(winlen,round(4*(1+opt.win_ls_marg)*Hm));
            end
        end
        % winlen = max(winlen,round(fs*10/1000));
        winlen = ceil(winlen/2)*2+1;

        % Get the time indices in the window
        is = find(f0s(:,1)>=(f0s(ind,1)-(winlen-1)/(fs*2)) & f0s(:,1)<=(f0s(ind,1)+(winlen-1)/(fs*2)));
        is = [is(1)-1; is; is(end)+1];
        is = is(find(is>=1 & is<=length(f0s(:,1))));

        winf0 = min(f0s(is,2));
    end

return
