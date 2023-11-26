function plot_camera(P, s)
    [center, C_axis] = camera_center_and_axis(P);

    scatter3(center(1), center(2), center(3), 'filled');
    hold on;

    % Plot principal C_axis sd by the given factor
    quiver3(center(1), center(2), center(3), s * C_axis(1), s * C_axis(2), s * C_axis(3), 'LineWidth', 2);
    axis equal;

    % Set plot limits based on the camera center and sd C_axis
    xlim([center(1) - s, center(1) + s]);
    ylim([center(2) - s, center(2) + s]);
    zlim([center(3) - s, center(3) + s]);
legend("camera center","camera axis")
    grid on;

end