import antenna.*

function BPSO(num_particles, num_dimensions, max_iterations)
    particles = randi([0, 1], num_particles, num_dimensions, num_dimensions);
    velocities=zeros(num_particles, num_dimensions, num_dimensions);
    personal_best_positions = particles;
    personal_best_fitness=zeros(num_dimensions, num_dimensions);
    global_best_fitness = float('inf');
    for j=1:max_iterations
        for i=1:num_particles
            velocities(i)=velocities(i)+randi([0, 1], num_particles, num_dimensions, num_dimensions);
            velocities(i) = max(min(velocities(i), 1), 0);
            particles(i) = xor(particles(i), velocities(i));
            fitness=antenna.AntennaLoadPSO(particles(i));
            if fitness<personal_best_fitness(i)
                personal_best_positions(i) = particles(i);
                personal_best_fitness(i) = fitness;
            elseif fitness < global_best_fitness
                global_best_position = particles(i);
                global_best_fitness = fitness;
            end
        end
    end
    global_best_position, global_best_fitness
end

            
            
            