function ap = avg_precision(g_truth, activation)
    %ap = tp / (fp + tp)
    threshold = 0.1;
    g_t_pos = g_truth > threshold;
    g_t_neg = g_truth < -1*threshold;
    pred_pos = activation > 0;
    pred_neg = activation < 0;
    tp_pos = g_t_pos & pred_pos; tp_neg = g_t_neg & pred_neg;
    fp_pos = (~g_t_pos) & pred_pos; fp_neg = (~g_t_neg) & pred_neg;
    tp = (sum(tp_pos, "all") + sum(tp_neg, "all")); fp = (sum(fp_pos, "all") + sum(fp_neg, "all"));
    ap = tp / (tp + fp);

end