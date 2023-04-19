import java.util.*;
import java.util.List;
import java.util.ArrayList;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;


class Main {
  public static void main(String[] args) {
    //lê a quantidade de operários e de tarefas
    Scanner scanner = new Scanner(System.in);
    int qtdOperario = scanner.nextInt();
    int qtdTarefa = scanner.nextInt();

    List<Tarefa> listaTarefa = new ArrayList<>();
    
    for (int i = 1; i <= qtdTarefa; i++) {
      int id  = scanner.nextInt();
      int tempo = scanner.nextInt();

      Tarefa tarefa = new Tarefa(id, tempo);
      listaTarefa.add(tarefa);
      
      while (scanner.hasNextInt()) {
        tarefa.novaDependencia(dependencias);
      }

    }
    scanner.close();

// Cria uma fila para armazenar as tarefas
    Queue<Tarefa> filaAtividades = new LinkedList<>();

    // Adiciona as tarefas sem dependências na fila
    for (Tarefa tarefa : tarefa) {
        if (tarefa.dependencias.isEmpty()) {
            filaAtividades.add(tarefa);
        }
    }

    // Cria um pool de threads com o número de trabalhadores especificado
    ExecutorService executor = Executors.newFixedThreadPool(qtdOperario);

    // Enquanto houver tarefas na fila, processa as próximas tarefas
    while (!filaAtividades.isEmpty()) {
        // Remove a próxima tarefa da fila
        Tarefa novaAtividade = filaAtividades.remove();

        // Verifica se todas as dependências da tarefa já foram concluídas
        if (novaAtividade.hasUnfinishedDependencies()) {
            // Se não foram, adiciona a tarefa novamente no final da fila
            filaAtividades.add(novaAtividade);
        } else {
            // Se todas as dependências foram concluídas, executa a tarefa
            executor.execute(novaAtividade);
        }
    }

    // Aguarda a conclusão de todas as tarefas
    executor.shutdown();
    try {
        // executor.awaitTermination(Long. , TimeUnit.MILISECONDS);
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
    
  }
}

public class Tarefa{
  private int id;
  private int tempo;
  private List<Tarefa> dependencias;
  private boolean finalizada;

  public Tarefa(int id, int tempo) {
    this.id = id;
    this.tempo = tempo;
    this.dependencias = new ArrayList<>();
    this.finalizada = false;
  }
  public int tarefaId(){
    return id;
  }
  public void novaDependencia(Tarefa tarefa) {
    dependencias.add(tarefa);
  }

  public boolean foiFinalizada() {
    return finalizada;
  }
}

public class Operario implements Runnable {
  private final int id;
  private final Queue<Tarefa> tarefasCompletas;
  private final List<Tarefa> tarefasIncompletas;

  public Operario(int id, Queue<Tarefa> tarefasCompletas, List<Tarefa> tarefasIncompletas) {
    this.id = id;
    this.tarefasCompletas = tarefasCompletas;
    this.tarefasIncompletas = tarefasIncompletas;
  }

  @Override
  public void run() {
    // ExecutorService executor = Executors.newFixedThreadPool(qtdOperario);
    while (true) {
      synchronized (tarefasCompletas) {
        if(!tarefasCompletas.isEmpty()){
          Tarefa tarefa = tarefasCompletas.poll();
          System.out.println("tarefa " + tarefa.tarefaId() + " feita");
        }
      }

      List<Tarefa> proxTarefa = new ArrayList<>();
      synchronized (tarefasIncompletas) {
        for (Tarefa tarefa : tarefasIncompletas) {
          if (tarefa.foiFinalizada()) {
            proxTarefa.add(tarefa);
          }
        }

        tarefasIncompletas.removeAll(proxTarefa);
      }

      for (Tarefa tarefa : proxTarefa) {
        executor.execute(new Operario(tarefa));
      }

    }

    try {
        Thread.sleep(10);
    } catch (InterruptedException e) {
        e.printStackTrace();
    }
  }
}
