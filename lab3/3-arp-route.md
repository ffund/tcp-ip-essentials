## Exercises with a host's routing table

You may have thought a routing table is only relevant when there are routers connecting multiple networks; but routing tables are also used at end hosts to determine how to send packets, even on a single segment!

In this exercise, we will see how a host uses its routing table every time it sends an IP packet - even before ARP is used! We'll also see how the ARP table and routing table together determine what happens to that packet.

We will observe all of the outcomes described in this flow chart of ARP table/routing table interaction:

[![](https://mermaid.ink/img/pako:eNqtlN9PwjAQx_-VS1_ERKO-LmoCAwEjhPjjyflQ1oM1bC22nWQR_3evbALTEX1wT83d9T7f712zdxZrgSxgc8OXCTx2IwX0tZ8jdqf1AvIlCLROKu6kVjCcgFRgdE6ROTg-TTFiL1BdgtPT63XERtzFic_7OgRpL6fm7FpIg7FLC4i1UnRCAa3-1flxxNbQIVyYYLwAOfvG29ylHp7bvp9smXXkWENWo_quXep6jy43CtAYbYKy1xjdSpuF75krgzxOGls2u3iTHObc4YoXXv7FRn64L_8r-5v0TsUZ1pJruKFmD6gEON04ipV0SS2xCSfauiMLo3YIXAiD1v4AjbXzSragHoEeTeE5VK_TNywB3_Y9LcqwJU1-HF6swdecqlr2eEvpVZQyvUwLQtz8TDmZIc2TksM9nxbTWQDDcDQp3XT3JDztdlQtcEBe98NltFXXvVMWHvDfP-B_t8C_eu83Grz9b4M7Yc3or7EP_vKCqmZH5bNufDjhgRc6YCcsQ5NxKejH8e6LI-YSzCgb0FHgjOcpjSBSH1SaLwWxekI6bVgw46nFE8Zzpx8KFW8DZVVXcvoRZVX04xMdPYFn)](https://mermaid.live/edit#pako:eNqtlN9PwjAQx_-VS1_ERKO-LmoCAwEjhPjjyflQ1oM1bC22nWQR_3evbALTEX1wT83d9T7f712zdxZrgSxgc8OXCTx2IwX0tZ8jdqf1AvIlCLROKu6kVjCcgFRgdE6ROTg-TTFiL1BdgtPT63XERtzFic_7OgRpL6fm7FpIg7FLC4i1UnRCAa3-1flxxNbQIVyYYLwAOfvG29ylHp7bvp9smXXkWENWo_quXep6jy43CtAYbYKy1xjdSpuF75krgzxOGls2u3iTHObc4YoXXv7FRn64L_8r-5v0TsUZ1pJruKFmD6gEON04ipV0SS2xCSfauiMLo3YIXAiD1v4AjbXzSragHoEeTeE5VK_TNywB3_Y9LcqwJU1-HF6swdecqlr2eEvpVZQyvUwLQtz8TDmZIc2TksM9nxbTWQDDcDQp3XT3JDztdlQtcEBe98NltFXXvVMWHvDfP-B_t8C_eu83Grz9b4M7Yc3or7EP_vKCqmZH5bNufDjhgRc6YCcsQ5NxKejH8e6LI-YSzCgb0FHgjOcpjSBSH1SaLwWxekI6bVgw46nFE8Zzpx8KFW8DZVVXcvoRZVX04xMdPYFn)


### Exercise - directly connected route

In a previous experiment, we saw that a host that needs to send an IP packet can use ARP to resolve a destination IP address to a MAC address. We observed three possible outcomes:

* a host already has the destination IP address in its ARP table. In this case, it will directly send the IP packet with the destination host's MAC address (from the ARP table) in the destination address field of the Layer 2 header.
* a host already does not already have the destination IP address in its ARP table, and it sends an ARP request to resolve the address, and receives an ARP reply. Then, it will send the IP packet with the destination host's MAC address (from the ARP reply) in the destination address field of the Layer 2 header.
* a host already does not already have the destination IP address in its ARP table, and it sends an ARP request to resolve the address, but does not receive an ARP reply. Then, it will send itself an ICMP Destination Unreachable: Host Unreachable message, indicating that it cannot reach the destination IP address. The IP packet is not sent.

However, these three scenarios only occur if the host _first_ checks its routing table, and determines that the route that matches this destination address is a **directly connected** route.

[![](https://mermaid.ink/img/pako:eNqtlNFv2jAQxv-Vk_dQKrXa9rhsq0QDBaaBUNs9LXsw8YVYODaznaKo9H_vmaRA2qD1YXmK7rvc7_vOVh5ZagSyiC0tX-dwP0g00JMq7twAM8glZFKp6EP2Jftaa_3fCftpzArKNQh0XmrupdEwmYPUYE1JlSV4vlCYsD_QfASXl1fbhE25T_Oghz4E6b4t7McrIS2mXlWQGq3pDQX0Rt8_nSdsC9eEi3NMVyCzV7zdtzQjcPu38z2zjZwZKFrUMHVAU2_Rl1YDWmtsVM-aod8YuwozS22Rp3nnyO4UD5LDknvc8CrY_7yzHx_bf1H_Zf264Uxa4hZuaNgdagHedK5iI33eEnbl3Dh_5mDaj4ELYdG5N6CZ8cHJHjQk0L2tAof6jXrAGvDqvBdVXXbkKawjmLX4t6SunjvfU4YNpZbXqiLEzVvJywJpnyROjnI6VFkEk3g6r9MMjiz8OpxRc4Bjynpcrqu9tu-Ds_hE_tGJ_IcDfG_2UWfAH_874MFYN_pl7eP33KBm2Fl9rTsvTnziho4TzS5YgbbgUtBv5TG0J8znWJAe0avAjJeKlpDoJ2ot14JoQyG9sSzKuHJ4wXjpzV2l032h7hpITr-poqk-PQM62or1)](https://mermaid.live/edit#pako:eNqtlNFv2jAQxv-Vk_dQKrXa9rhsq0QDBaaBUNs9LXsw8YVYODaznaKo9H_vmaRA2qD1YXmK7rvc7_vOVh5ZagSyiC0tX-dwP0g00JMq7twAM8glZFKp6EP2Jftaa_3fCftpzArKNQh0XmrupdEwmYPUYE1JlSV4vlCYsD_QfASXl1fbhE25T_Oghz4E6b4t7McrIS2mXlWQGq3pDQX0Rt8_nSdsC9eEi3NMVyCzV7zdtzQjcPu38z2zjZwZKFrUMHVAU2_Rl1YDWmtsVM-aod8YuwozS22Rp3nnyO4UD5LDknvc8CrY_7yzHx_bf1H_Zf264Uxa4hZuaNgdagHedK5iI33eEnbl3Dh_5mDaj4ELYdG5N6CZ8cHJHjQk0L2tAof6jXrAGvDqvBdVXXbkKawjmLX4t6SunjvfU4YNpZbXqiLEzVvJywJpnyROjnI6VFkEk3g6r9MMjiz8OpxRc4Bjynpcrqu9tu-Ds_hE_tGJ_IcDfG_2UWfAH_874MFYN_pl7eP33KBm2Fl9rTsvTnziho4TzS5YgbbgUtBv5TG0J8znWJAe0avAjJeKlpDoJ2ot14JoQyG9sSzKuHJ4wXjpzV2l032h7hpITr-poqk-PQM62or1)


This first section is a review of 

[![](https://mermaid.ink/img/pako:eNqtVE1v2zAM_SuEdmgKuOh2nLcVSJzPYQmCtjvNOygWHQuxpUySGxhN_3up2M1H66A9zCeDj-J7jyT4yBItkIVsafg6g_t-rIC-JOfW9jGFTEIq8zz8lH5Nv9VY90_Mfmm9gnINAq2TijupFUzmIBUYXVJkCY4vcozZX2gewdXVzTZmU-6SzOM-D0Ha7wtzfSOkwcTlFSRaKfpDAZ3Rj8-XMdtCj-iiDJMVyPQV3-4t1fC83dv5nvOUcqahOGH1VftU9RZdaRSgMdqEda0Zuo02K1-zVAZ5krWWbHfxIDksucMNr7z8Lzv50bH8F_Q96b2GZ3ICbmFIxe5QCXC6tRUb6bITYBfOtHUXFqbdCLgQBq19QzTTzivZEw2I6N5Unofydf6ANcGreS-qOmxJk2-HF2vwX0lZHXu5Zxk0LDW8ziuiGL6FnCyQ-kng5MinxTwNYRJN57Wb_pGE34cZNQMck9fjcB3tnOo-KIvO-B-d8X8Y4Ee9j1oN_vzfBg_C2qlf2j7-yAY1xS7qtW5dnOjMho6P7gd0g14wCIbBhM4IHQ8WsAJNwaWge_PoE2PmMizoYUi_AlNe5tSdWD1RarkWJGMgpNOGhSnPLQaMl07fVSrZB-qsvuR0v4om-vQMWCeRqA)](https://mermaid.live/edit#pako:eNqtVE1v2zAM_SuEdmgKuOh2nLcVSJzPYQmCtjvNOygWHQuxpUySGxhN_3up2M1H66A9zCeDj-J7jyT4yBItkIVsafg6g_t-rIC-JOfW9jGFTEIq8zz8lH5Nv9VY90_Mfmm9gnINAq2TijupFUzmIBUYXVJkCY4vcozZX2gewdXVzTZmU-6SzOM-D0Ha7wtzfSOkwcTlFSRaKfpDAZ3Rj8-XMdtCj-iiDJMVyPQV3-4t1fC83dv5nvOUcqahOGH1VftU9RZdaRSgMdqEda0Zuo02K1-zVAZ5krWWbHfxIDksucMNr7z8Lzv50bH8F_Q96b2GZ3ICbmFIxe5QCXC6tRUb6bITYBfOtHUXFqbdCLgQBq19QzTTzivZEw2I6N5Unofydf6ANcGreS-qOmxJk2-HF2vwX0lZHXu5Zxk0LDW8ziuiGL6FnCyQ-kng5MinxTwNYRJN57Wb_pGE34cZNQMck9fjcB3tnOo-KIvO-B-d8X8Y4Ee9j1oN_vzfBg_C2qlf2j7-yAY1xS7qtW5dnOjMho6P7gd0g14wCIbBhM4IHQ8WsAJNwaWge_PoE2PmMizoYUi_AlNe5tSdWD1RarkWJGMgpNOGhSnPLQaMl07fVSrZB-qsvuR0v4om-vQMWCeRqA)


For this exercise, we will configure addresses and subnet masks on four hosts, as follows:

| Host          | IP address    | Subnet mask     |
| ------------- | ------------- |-----------------|
| romeo         | 10.10.0.100   | 255.255.255.240 |
| juliet        | 10.10.0.101   | 255.255.255.0   |
| hamlet        | 10.10.0.102   | 255.255.255.0   |
| ophelia       | 10.10.0.120   | 255.255.255.240 |


To change the IP address and/or netmask of a given interface on our hosts, use the syntax

```
sudo ifconfig INTERFACE IP-ADDRESS netmask NETMASK
```

substituting appropriate values for `INTERFACE` name, `IP-ADDRESS`, and `NETMASK`. 

When a network interface is configured with an IP address and subnet mask, a "directly connected network" rule is *automatically* added to the routing table on that device. This rule applies to all destination addresses in the same subnet as the network interface, and says to send all traffic directly (without an "next hop" router) from that interface. 


Run 


```
route -n
```

on each host, and observe the directly connected route. Save the routing tables for your lab report. 


### Exercise - no matching route

[![](https://mermaid.ink/img/pako:eNqtVMFu2zAM_RVCOzQFUnQ7ztsKpHaaZFiCoO1O8w6KRcdCbCmT5AZG038vFbtJ3DpoD_PJ4KP43iMJPrJEC2QBWxq-zuA-ihXQl-Tc2ghTyCSkMs-DT-nX9FuNDf7E7JfWKyjXINA6qbiTWsFkDlKB0SVFluD4IseY_YXmEVxcXG1jNuUuyTzu8xCk_b4wl1dCGkxcXkGilaI_FNAb_fh8HrMtXBNdmGGyApm-4tu9pRqed3A733O2KWcaiharrxpR1Vt0pVGAxmgT1LVm6DbarHzNUhnkSdZZstvFg-Sw5A43vPLyv-zkh8fyX9D3pF83PJMWuIUbKnaHSoDTna3YSJe1gF0409adWZgOQuBCGLT2DdFMO69kTzQkontTeR7K1_kD1gSv5r2o6rAlTb4dXqzBfyVl9ez5nmXYsNTwOq-I4uYt5GSB1E8CJ0c-LeZpAJNwOq_dREcSfh9m1AxwTF6Pw3W019Z9UBae8D864f8wwI96H3Ua_Pm_DR6EdVO_tH38kQ1qip3Va925OOGJDR0f3Q8Y9CM6IHQ2WJ8VaAouBV2aR58SM5dhQU8C-hWY8jKnvsTqiVLLtSABQyGdNixIeW6xz3jp9F2lkn2gzookp8tVNNGnZ0GokFI)](https://mermaid.live/edit#pako:eNqtVMFu2zAM_RVCOzQFUnQ7ztsKpHaaZFiCoO1O8w6KRcdCbCmT5AZG038vFbtJ3DpoD_PJ4KP43iMJPrJEC2QBWxq-zuA-ihXQl-Tc2ghTyCSkMs-DT-nX9FuNDf7E7JfWKyjXINA6qbiTWsFkDlKB0SVFluD4IseY_YXmEVxcXG1jNuUuyTzu8xCk_b4wl1dCGkxcXkGilaI_FNAb_fh8HrMtXBNdmGGyApm-4tu9pRqed3A733O2KWcaiharrxpR1Vt0pVGAxmgT1LVm6DbarHzNUhnkSdZZstvFg-Sw5A43vPLyv-zkh8fyX9D3pF83PJMWuIUbKnaHSoDTna3YSJe1gF0409adWZgOQuBCGLT2DdFMO69kTzQkontTeR7K1_kD1gSv5r2o6rAlTb4dXqzBfyVl9ez5nmXYsNTwOq-I4uYt5GSB1E8CJ0c-LeZpAJNwOq_dREcSfh9m1AxwTF6Pw3W019Z9UBae8D864f8wwI96H3Ua_Pm_DR6EdVO_tH38kQ1qip3Va925OOGJDR0f3Q8Y9CM6IHQ2WJ8VaAouBV2aR58SM5dhQU8C-hWY8jKnvsTqiVLLtSABQyGdNixIeW6xz3jp9F2lkn2gzookp8tVNNGnZ0GokFI)

### Exercise - route via gateway

[![](https://mermaid.ink/img/pako:eNqtVMFu2zAM_RVCOzQFXGw7ztsKpE6apFiCoO1O8w6KRcdCbCmT5AZG038fFbtJ3DpoD_XJ4KP43iMJPrJEC2QhWxq-zuB-ECugL8m5tQNMIZOQyjwPP6Xf0u811v8Ts19ar6Bcg0DrpOJOagWTOUgFRpcUWYLjixxj9heaR3BxcbmN2ZS7JPO4z0OQ9sfCfL4U0mDi8goSrRT9oYDe6OeX85ht4YroogyTFcj0Bd_uLdXwvP3b-Z6zTTnTULRYfdUBVb1FVxoFaIw2YV1rhm6jzcrXLJVBnmSdJbtdPEgOS-5wwysv_-tOfnQs_xl9S_pVwzNpgVu4pmJ3qAQ43dmKjXRZC9iFM23dmYVpPwIuhEFrXxHNtPNK9kRDIro3leehfJ0_YE3wYt6Lqg5b0uTb4cUa_FdSVs-e71mGDUsNr_OKKK5fQ04WSP0kcHLk02KehjCJpvPazeBIwu_DjJoBjsnrcbiO9tq6D8qiE_5HJ_wfBvhe76NOgzcfbfAgrJv6ue3j92xQU-ysXuvOxYlObOj46H5AP4iCUTAObuiM0PFgASvQFFwKujePPjFmLsOCHob0KzDlZU7didUTpZZrQTKGQjptWJjy3GLAeOn0XaWSfaDOGkhO96took__AVrZka4)](https://mermaid.live/edit#pako:eNqtVMFu2zAM_RVCOzQFXGw7ztsKpE6apFiCoO1O8w6KRcdCbCmT5AZG038fFbtJ3DpoD_XJ4KP43iMJPrJEC2QhWxq-zuB-ECugL8m5tQNMIZOQyjwPP6Xf0u811v8Ts19ar6Bcg0DrpOJOagWTOUgFRpcUWYLjixxj9heaR3BxcbmN2ZS7JPO4z0OQ9sfCfL4U0mDi8goSrRT9oYDe6OeX85ht4YroogyTFcj0Bd_uLdXwvP3b-Z6zTTnTULRYfdUBVb1FVxoFaIw2YV1rhm6jzcrXLJVBnmSdJbtdPEgOS-5wwysv_-tOfnQs_xl9S_pVwzNpgVu4pmJ3qAQ43dmKjXRZC9iFM23dmYVpPwIuhEFrXxHNtPNK9kRDIro3leehfJ0_YE3wYt6Lqg5b0uTb4cUa_FdSVs-e71mGDUsNr_OKKK5fQ04WSP0kcHLk02KehjCJpvPazeBIwu_DjJoBjsnrcbiO9tq6D8qiE_5HJ_wfBvhe76NOgzcfbfAgrJv6ue3j92xQU-ysXuvOxYlObOj46H5AP4iCUTAObuiM0PFgASvQFFwKujePPjFmLsOCHob0KzDlZU7didUTpZZrQTKGQjptWJjy3GLAeOn0XaWSfaDOGkhO96took__AVrZka4)


### Exercise - asymmetric subnet masks