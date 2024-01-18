*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE TTV.CHECK.BAL

    $INSERT GLOBUS.BP I_COMMON
    $INSERT GLOBUS.BP I_EQUATE
    $INSERT GLOBUS.BP I_ENQUIRY.COMMON
    $INSERT BP I_F.TT.VAULT


    FN.TTV='F.TT.VAULT'
    F.TTV =''

    CALL OPF(FN.TTV,F.TTV)

    Y.TOT.AMT =R.NEW(TTV.T.AMT)
    Y.TDATE = ID.NEW[6,8]

    IF Y.TDATE EQ TODAY THEN
        CALL NOFILE.DAYEND.CASH.MEMO.LOCAL(Y.CIH)
        FINDSTR 'Closing Balance' IN Y.CIH  SETTING  Y.POS THEN  END
        Y.CLOSE.AMT = FIELD(Y.CIH<Y.POS>,'Closing Balance',2)
        Y.CL.AMT = FIELD(Y.CLOSE.AMT,"*",2)
        Y.DIF.BAL = Y.CL.AMT - Y.TOT.AMT

        IF Y.TOT.AMT NE Y.CL.AMT THEN
            AF = TTV.T.AMT
            AV =1
            ETEXT= 'Your Closing Balance:':Y.CL.AMT:' Mismatch With Total Denomination Amount:':Y.TOT.AMT:' Differ Balance: ':Y.DIF.BAL
            CALL STORE.END.ERROR
        END
    END
    RETURN
END
