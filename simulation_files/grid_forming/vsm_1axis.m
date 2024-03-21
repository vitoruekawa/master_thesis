classdef vsm_1axis < handle

    properties
        omega_st
        Xd
        Xd_prime
        Xq
        Tdo
        M
        D
        P_st
        V_st
    end

    methods

        function obj = vsm_1axis(vsm_params)
            obj.omega_st = vsm_params{:, 'omega_st'};
            obj.Xd = vsm_params{:, 'Xd'};
            obj.Xd_prime = vsm_params{:, 'Xd_prime'};
            obj.Xq = vsm_params{:, 'Xq'};
            obj.Tdo = vsm_params{:, 'Tdo'};
            obj.M = vsm_params{:, 'M'};
            obj.D = vsm_params{:, 'D'};
        end

        function nx = get_nx(obj)
            nx = 3;
        end

        function nu = get_nu(obj)
            nu = 0;
        end

        function vdq_hat = calculate_vdq_hat(obj, Idq, Eq, L_g, omega)
            Vd = obj.Xq * Idq(2) - omega * L_g * Idq(2);
            Vq = Eq - obj.Xd_prime * Idq(1) + omega * L_g * Idq(1);
            vdq_hat = [Vd; Vq];
        end

        function [d_delta, d_omega, d_Eq] = get_dx(obj, P, Pmech, Vfd, omega, Eq, idq)
            d_delta = omega - obj.omega_st;
            d_omega = (- obj.D * (omega - obj.omega_st) + Pmech - P) / obj.M;
            d_Eq = (Vfd - Eq - (obj.Xd - obj.Xd_prime) * idq(1)) / obj.Tdo;
        end

        function [delta_st, domega_st, Eq_st, Vfd] = get_equilibrium(obj, P, Q, V, I)
            Vabs = abs(V);
            Vangle = angle(V);

            delta_st = Vangle + atan(P * obj.Xq / (Q * obj.Xq + Vabs ^ 2));

            domega_st = obj.omega_st;

            Vd = real(V) * sin(delta_st) - imag(V) * cos(delta_st);
            Vq = real(V) * cos(delta_st) + imag(V) * sin(delta_st);

            Id = real(I) * sin(delta_st) - imag(I) * cos(delta_st);
            Iq = real(I) * cos(delta_st) + imag(I) * sin(delta_st);

            Eq_st = Id * obj.Xd_prime + Vq;
            Vfd = Eq_st + (obj.Xd - obj.Xd_prime) * Id;
        end

    end

end
