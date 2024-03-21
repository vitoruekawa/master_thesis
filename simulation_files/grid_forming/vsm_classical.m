classdef vsm_classical < handle

    properties
        omega_st
        Xd
        Xq
        M
        D
        P_st
        V_st
    end

    methods

        function obj = vsm_classical(vsm_params)
            obj.omega_st = vsm_params{:, 'omega_st'};
            obj.Xd = vsm_params{:, 'Xd'};
            obj.Xq = vsm_params{:, 'Xq'};
            obj.M = vsm_params{:, 'M'};
            obj.D = vsm_params{:, 'D'};
        end

        function nx = get_nx(obj)
            nx = 3;
        end

        function nu = get_nu(obj)
            nu = 0;
        end

        function vdq_hat = calculate_vdq_hat(obj, Idq, L_g, omega, Vfd)
            Vd = obj.Xq * Idq(2) - omega * L_g * Idq(2);
            Vq = Vfd - obj.Xd * Idq(1) + omega * L_g * Idq(1);
            vdq_hat = [Vd; Vq];
        end

        function [d_delta, d_omega] = get_dx(obj, P, Pmech, omega)
            d_delta = omega - obj.omega_st;
            d_omega = (- obj.D * (omega - obj.omega_st) + Pmech - P) / obj.M;
        end

        function [delta_st, domega_st] = get_equilibrium(obj, P, Q, V, I)
            Vabs = abs(V);
            Vangle = angle(V);

            delta_st = Vangle + atan(P * obj.Xq / (Q * obj.Xq + Vabs ^ 2));
            domega_st = obj.omega_st;
        end

    end

end
