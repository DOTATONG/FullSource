#include "stdafx.h"
#include "./krloptimization.h"
#include "./SO3Represent.h"

int UpdateFPS(KRLOptimization* pRLOptimization)
{
    double fCurrentTime = 0.0;
    double fEvaluationTime = 0.0;

    fCurrentTime = g_pRL->m_fTime;

    KG_PROCESS_SUCCESS(!(pRLOptimization->fStartTime > 0.0 && fCurrentTime > pRLOptimization->fStartTime));

    ++pRLOptimization->dwFrameCount;

    KG_PROCESS_SUCCESS(fCurrentTime <= pRLOptimization->fFPSUpdateExpiredTime);

    fEvaluationTime = g_pRL->m_TableList.GetNumber(RL_NUMBER_OPTIMIZATION_EVALUATION_TIME);
    KG_PROCESS_SUCCESS(fEvaluationTime <= 0.0f);

    pRLOptimization->fFPSUpdateExpiredTime = fCurrentTime + fEvaluationTime;

    pRLOptimization->dwFPS = (DWORD)((double)pRLOptimization->dwFrameCount / (fEvaluationTime / 1000.0));
    pRLOptimization->dwFrameCount = 0;

Exit1:
    return true;
}

int InitOptimization(KRLOptimization* pRLOptimization)
{
    int nResult = false;

    KGLOG_PROCESS_ERROR(pRLOptimization);

    pRLOptimization->fStartTime = 0.0;

    pRLOptimization->dwFPS = 100;
    pRLOptimization->dwFrameCount = 0;
    pRLOptimization->fFPSUpdateExpiredTime = 0.0;

    pRLOptimization->dwCurrentOptimizeFPS = 100;
    pRLOptimization->fOptimizeEvaluationExpiredTime = 0.0f;
    pRLOptimization->dwOptimizeLevel = 0;

    nResult = true;
Exit0:
    return nResult;
}

int StartOptimization(KRLOptimization* pRLOptimization)
{
    int nResult = false;
    double fStartTime = 0.0;
    double fEvaluationTime = 0.0;

    KGLOG_PROCESS_ERROR(pRLOptimization);

    fStartTime = g_pRL->m_TableList.GetNumber(RL_NUMBER_OPTIMIZATION_START_TIME);
    fEvaluationTime = g_pRL->m_TableList.GetNumber(RL_NUMBER_OPTIMIZATION_EVALUATION_TIME);

    pRLOptimization->fStartTime = g_pRL->m_fTime + fStartTime;
    pRLOptimization->fFPSUpdateExpiredTime = pRLOptimization->fStartTime + fEvaluationTime;

    nResult = true;
Exit0:
    return nResult;
}

static int Optimize(KRLOptimizationModel const* pRLOptimizationModel)
{
    int nResult = false;

    KGLOG_PROCESS_ERROR(pRLOptimizationModel);

    g_pRL->m_CurrentTerrainLeanOption.bDisable = pRLOptimizationModel->bDisableTerrainLean;

    g_pRL->m_CurrentOptimizationOption.bHideDoodadEffect = pRLOptimizationModel->bHideDoodadEffect;
    g_pRL->m_CurrentOptimizationOption.bHideCorpseEffect = pRLOptimizationModel->bHideCorpseEffect;
    g_pRL->m_CurrentOptimizationOption.bHideDoodad = pRLOptimizationModel->bHideDoodad;
    g_pRL->m_CurrentOptimizationOption.bHideCorpse = pRLOptimizationModel->bHideCorpse;
    g_pRL->m_CurrentOptimizationOption.bHideEnemyNpc = pRLOptimizationModel->bHideEnemyNpc;
    g_pRL->m_CurrentOptimizationOption.bHideNeutralityNpc = pRLOptimizationModel->bHideNeutralityNpc;
    g_pRL->m_CurrentOptimizationOption.bHidePartyNpc = pRLOptimizationModel->bHidePartyNpc;
    g_pRL->m_CurrentOptimizationOption.bHideAllyNpc = pRLOptimizationModel->bHideAllyNpc;
    g_pRL->m_CurrentOptimizationOption.bHideEnemyPlayer = pRLOptimizationModel->bHideEnemyNpc;
    g_pRL->m_CurrentOptimizationOption.bHideNeutralityPlayer = pRLOptimizationModel->bHideNeutralityPlayer;
    g_pRL->m_CurrentOptimizationOption.bHidePartyPlayer = pRLOptimizationModel->bHidePartyPlayer;
    g_pRL->m_CurrentOptimizationOption.bHideAllyPlayer = pRLOptimizationModel->bHideAllyPlayer;
    g_pRL->m_CurrentOptimizationOption.bHideSelf = pRLOptimizationModel->bHideSelf;
    g_pRL->m_CurrentOptimizationOption.bSelfUniform = pRLOptimizationModel->bSelfUniform;
    g_pRL->m_CurrentOptimizationOption.bDoodadUniform = pRLOptimizationModel->bDoodadUniform;
    g_pRL->m_CurrentOptimizationOption.bCorpseUniqueUniform = pRLOptimizationModel->bCorpseUniqueUniform;
    g_pRL->m_CurrentOptimizationOption.bNpcUniform = pRLOptimizationModel->bNpcUniform;
    g_pRL->m_CurrentOptimizationOption.bPlayerUniqueUniform = pRLOptimizationModel->bPlayerUniqueUniform;
    g_pRL->m_CurrentOptimizationOption.bPlayerGenderUniform = pRLOptimizationModel->bPlayerGenderUniform;
    g_pRL->m_CurrentOptimizationOption.bPlayerRoleTypeUniform = pRLOptimizationModel->bPlayerRoleTypeUniform;
    g_pRL->m_CurrentOptimizationOption.bPlayerForceUniform = pRLOptimizationModel->bPlayerForceUniform;
    g_pRL->m_CurrentOptimizationOption.bSkillAnimationUniform = pRLOptimizationModel->bSkillAnimationUniform;
    g_pRL->m_CurrentOptimizationOption.bDisableAnimationBlend = pRLOptimizationModel->bDisableAnimationBlend;

    nResult = true;
Exit0:
    return nResult;
}

int UpdateOptimization(KRLOptimization* pRLOptimization)
{
    int nRetCode = false;
    int nResult = false;
    KRLOptimizationModel const* pRLOptimizationModel = NULL;
    KRLOptimizationModel const* pNewRLOptimizationModel = NULL;

    StartProfile(&g_pRL->m_Profile, KRLPROFILE_OPTIMIZATION);

    KG_PROCESS_SUCCESS(!g_pRL->m_CurrentOptimizationOption.bAuto);

    pRLOptimizationModel = g_pRL->m_TableList.GetOptimizationModel(pRLOptimization->dwOptimizeLevel);
    KGLOG_PROCESS_ERROR(pRLOptimizationModel);

    if (g_pRL->m_fTime < pRLOptimization->fOptimizeEvaluationExpiredTime)
    {
        // evaluating
        pRLOptimization->dwCurrentOptimizeFPS = (DWORD)((float)pRLOptimization->dwCurrentOptimizeFPS * 0.6f + (float)pRLOptimization->dwFPS * 0.4f);
    }
    else
    {
        // evaluation

        if (pRLOptimization->dwCurrentOptimizeFPS > pRLOptimizationModel->dwHighFPS)
        {
            pNewRLOptimizationModel = g_pRL->m_TableList.GetOptimizationModel(pRLOptimization->dwOptimizeLevel - 1);
            if (pNewRLOptimizationModel)
            {
                pRLOptimizationModel = pNewRLOptimizationModel;

                --pRLOptimization->dwOptimizeLevel;

                nRetCode = Optimize(pRLOptimizationModel);
                KGLOG_PROCESS_ERROR(nRetCode);
            }
        }
        else if (pRLOptimization->dwCurrentOptimizeFPS < pRLOptimizationModel->dwLowFPS)
        {
            pNewRLOptimizationModel = g_pRL->m_TableList.GetOptimizationModel(pRLOptimization->dwOptimizeLevel + 1);
            if (pNewRLOptimizationModel)
            {
                pRLOptimizationModel = pNewRLOptimizationModel;

                ++pRLOptimization->dwOptimizeLevel;

                nRetCode = Optimize(pRLOptimizationModel);
                KGLOG_PROCESS_ERROR(nRetCode);
            }
        }

        // evaluate again
        pRLOptimization->fOptimizeEvaluationExpiredTime = g_pRL->m_fTime + pRLOptimizationModel->dwEvaluationTime;
    }

Exit1:
    nResult = true;
Exit0:
    if (!nResult)
    {
        if (pRLOptimization)
        {
            nRetCode = InitOptimization(pRLOptimization);
            KGLOG_CHECK_ERROR(nRetCode);
        }
    }
    StopProfile(&g_pRL->m_Profile, KRLPROFILE_OPTIMIZATION);
    return nResult;
}

int Optimize(DWORD dwLevel)
{
    int nRetCode = false;
    int nResult = false;
    KRLOptimizationModel const* pRLOptimizationModel = NULL;

    pRLOptimizationModel = g_pRL->m_TableList.GetOptimizationModel(dwLevel);
    KGLOG_PROCESS_ERROR(pRLOptimizationModel);

    nRetCode = Optimize(pRLOptimizationModel);
    KGLOG_PROCESS_ERROR(nRetCode);

    nResult = true;
Exit0:
    return nResult;
}

