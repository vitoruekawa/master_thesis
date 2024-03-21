classdef avr_sauer < avr
        
    properties
        Te
        Ke
        Tf
        Kf
        Ta
        Ka
        Vref
    end
    
    methods
        function obj = avr_sauer(avr_tab)
            obj.Te = avr_tab{:, 'Te'};
            obj.Ke = avr_tab{:, 'Ke'};
            obj.Tf = avr_tab{:, 'Tf'};
            obj.Kf = avr_tab{:, 'Kf'};
            obj.Ta = avr_tab{:, 'Ta'};
            obj.Ka = avr_tab{:, 'Ka'};

        end
        
        function name_tag = get_state_name(obj)
            name_tag = {'Vfield', 'Rf', 'Vr'};
        end
        
        function nx = get_nx(obj)
            nx = 3;
        end
        
        function x = initialize(obj, Vfd_st, Vabs)
            obj.Vabs_st = Vabs;
            Vr_st = (obj.Ke + 0.0039 * exp(1.555* Vfd_st)) * Vfd_st;
            Rf_st = obj.Kf * Vfd_st / obj.Tf;
            obj.Vref = Vabs + Vr_st / obj.Ka;
            x = [Vfd_st; Rf_st; Vr_st];
        end

        function [dx, Vfd] = get_Vfd(obj, x_avr, Vabs, u)
            Vfd = x_avr(1);
            Rf = x_avr(2);
            Vr = x_avr(3);

            dVfd = (-(obj.Ke + 0.0039 * exp(1.555* Vfd)) * Vfd + Vr) / obj.Te;
            dRf = (-Rf + obj.Kf * Vfd / obj.Tf) / obj.Tf;
            dVr = (-Vr + obj.Ka * Rf - (obj.Ka * obj.Kf / obj.Tf) * Vfd + obj.Ka * (obj.Vref - Vabs)) / obj.Ta;
            dx = [dVfd; dRf; dVr];
        end
    end
end