package com.feiyu.game.dialog;

import android.os.Bundle;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import com.feiyu.common.dialog.AbsDialogFragment;
import com.feiyu.common.interfaces.OnItemClickListener;
import com.feiyu.game.R;
import com.feiyu.game.adapter.GameAdapter;
import com.feiyu.game.util.GamePresenter;

/**
 * Created by cxf on 2018/10/31.
 */

public class GameDialogFragment extends AbsDialogFragment implements OnItemClickListener<Integer>, View.OnClickListener {

    private GamePresenter mGamePresenter;

    @Override
    protected int getLayoutId() {
        return R.layout.dialog_game;
    }

    @Override
    protected int getDialogStyle() {
        return R.style.dialog2;
    }

    @Override
    protected boolean canCancel() {
        return true;
    }

    @Override
    protected void setWindowAttributes(Window window) {
        window.setWindowAnimations(R.style.bottomToTopAnim);
        WindowManager.LayoutParams params = window.getAttributes();
        params.width = WindowManager.LayoutParams.MATCH_PARENT;
        params.height = WindowManager.LayoutParams.WRAP_CONTENT;
        params.gravity = Gravity.BOTTOM;
        window.setAttributes(params);
    }


    public void setGamePresenter(GamePresenter gamePresenter) {
        mGamePresenter = gamePresenter;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        mRootView.findViewById(R.id.btn_back).setOnClickListener(this);
        if (mGamePresenter != null) {
            RecyclerView recyclerView = mRootView.findViewById(R.id.recyclerView);
            recyclerView.setHasFixedSize(true);
            recyclerView.setLayoutManager(new GridLayoutManager(mContext, 3, GridLayoutManager.VERTICAL, false));
            GameAdapter adapter = new GameAdapter(mContext, mGamePresenter.getGameList());
            adapter.setOnItemClickListener(this);
            recyclerView.setAdapter(adapter);
        }
    }

    @Override
    public void onItemClick(Integer gameAction, int position) {
        dismiss();
        if (mGamePresenter != null) {
            mGamePresenter.startGame(gameAction);
        }
    }

    @Override
    public void onDestroy() {
        mGamePresenter = null;
        super.onDestroy();
    }

    @Override
    public void onClick(View v) {
        int i = v.getId();
        if (i == R.id.btn_back) {
            dismiss();

        }
    }
}
