classdef MenuBarComponent < matlab.ui.componentcontainer.ComponentContainer
    % A component in a Pseudo menu bar
    properties
        Width
        CurrentPosition
        Component 
    end
    properties (Access = protected, Transient, NonCopyable)
        %NumericField (1,4) matlab.ui.control.NumericEditField
        Grid matlab.ui.container.GridLayout
    end
    events (HasCallbackProperty, NotifyAccess = protected)
        WidthChanged % ValueChangedFcn callback property will be generated
    end
    
    
end