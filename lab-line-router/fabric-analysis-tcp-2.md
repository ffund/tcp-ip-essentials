::: {.cell .markdown}
### Data visualization
:::

::: {.cell .markdown}

To visualize the results of your experiment, you should first retrieve the data file `sender-ss.csv` from host romeo. To do that, execute the following command:

:::

::: {.cell .code}
```python
import os
slice.get_node("romeo").download_file(os.path.abspath("sender-ss.csv"), "/home/ubuntu/sender-ss.csv")
```
:::

::: {.cell .markdown}

In the Jupyter environment, click on the folder icon in the file browser on the left to make sure that you are located in your “Jupyter home” directory.

Then, you should see the `sender-ss.csv` file appear in the Jupyter file browser on the left.

Before running the following Python script to plot the `sender-ss.csv` file, in the Jupyter environment make sure that your `setup.ipynb` and `sender-ss.csv` files are on the same path in the file directory.

:::

::: {.cell .code}
```python
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("sender-ss.csv", names=['time', 'sender', 'retx_unacked', 'retx_cum', 'cwnd', 'ssthresh'])

# exclude the "control" flow
s = df.groupby('sender').size()
df_filtered = df[df.groupby("sender")['sender'].transform('size') > 100]

senders = df_filtered.sender.unique()

time_min = df_filtered.time.min()
cwnd_max = 1.1*df_filtered[df_filtered.time - time_min >=2].cwnd.max()
dfs = [df_filtered[df_filtered.sender==senders[i]] for i in range(3)]

fig, axs = plt.subplots(len(senders), sharex=True, figsize=(12,8))
fig.suptitle('CWND over time')
for i in range(len(senders)):
    if i==len(senders)-1:
        axs[i].plot(dfs[i]['time']-time_min, dfs[i]['cwnd'], label="cwnd")
        axs[i].plot(dfs[i]['time']-time_min, dfs[i]['ssthresh'], label="ssthresh")
        axs[i].set_ylim([0,cwnd_max])
        axs[i].set_xlabel("Time (s)");
    else:
        axs[i].plot(dfs[i]['time']-time_min, dfs[i]['cwnd'])
        axs[i].plot(dfs[i]['time']-time_min, dfs[i]['ssthresh'])
        axs[i].set_ylim([0,cwnd_max])


plt.tight_layout();
fig.legend(loc='upper right', ncol=2);
```
:::

::: {.cell .markdown}

You can return to this exercise and execute the above steps to visuaize results of TCP Cubic, TCP Vegas and TCP BBR.

:::