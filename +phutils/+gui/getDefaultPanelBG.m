function bg = getDefaultPanelBG()
    f = figure('Visible','off');
    p = uipanel(f);
    bg = p.BackgroundColor;
    delete(p); delete(f);
    