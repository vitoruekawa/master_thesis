classdef vsm_2axis < handle

    properties
        omega_st
        Xd
        Xd_prime
        Xq
        Xq_prime
        Tdo
        Tqo
        M
        D
        P_st
        V_st
    end

    methods

        function obj = vsm_2axis(vsm_params)
            obj.omega_st = vsm_params{:, 'omega_st'};
            obj.Xd = vsm_params{:, 'Xd'};
            obj.Xd_prime = vsm_params{:, 'Xd_prime'};
            obj.Xq = vsm_params{:, 'Xq'};
            obj.Xq_prime = vsm_params{:, 'Xq_prime'};
            obj.Tdo = vsm_params{:, 'Tdo'};
            obj.Tqo = vsm_params{:, 'Tqo'};
            obj.M = vsm_params{:, 'M'};
            obj.D = vsm_params{:, 'D'};
        end

        function nx = get_nx(obj)
            nx = 4;
        end

        function nu = get_nu(obj)
            nu = 0;
        end

        % State variables: theta and zeta (PI controller)
        function Vdq_hat = calculate_vdq_hat(obj, Idq, Ed, Eq, L_g, omega)
            Vd = Ed + obj.Xq_prime * Idq(2) - omega * L_g * Idq(2);
            Vq = Eq - obj.Xd_prime * Idq(1) + omega * L_g * Idq(1);
            Vdq_hat = [Vd; Vq];
        end

        function [d_delta, d_omega, d_Ed, d_Eq] = get_dx(obj, P, Pmech, Vfd, omega, Ed, Eq, idq)
            d_delta = omega - obj.omega_st;
            d_omega = (- obj.D * (omega - obj.omega_st) + Pmech - P) / obj.M;

            d_Ed = (- Ed + (obj.Xq - obj.Xq_prime) * idq(2)) / obj.Tqo;
            d_Eq = (Vfd - Eq - (obj.Xd - obj.Xd_prime) * idq(1)) / obj.Tdo;
        end

        function [delta_st, domega_st, Ed_st, Eq_st, Vfd] = get_equilibrium(obj, P, Q, V, I)
            Vabs = abs(V);
            Vangle = angle(V);

            delta_st = Vangle + atan((P * obj.Xq) / (Vabs^2 + Q * obj.Xq));

            domega_st = obj.omega_st;

            Vq = real(V) * cos(delta_st) + imag(V) * sin(delta_st);

            Id = real(I) * sin(delta_st) - imag(I) * cos(delta_st);
            Iq = real(I) * cos(delta_st) + imag(I) * sin(delta_st);

            Ed_st = (obj.Xq - obj.Xq_prime) * Iq;
            Eq_st = Id * obj.Xd_prime + Vq;
            Vfd = Eq_st + (obj.Xd - obj.Xd_prime) * Id;

        end

    end

end
