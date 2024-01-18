*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE JBL.S.EXTRACT.AMEND.MM

    $INSERT GLOBUS.BP I_COMMON
    $INSERT GLOBUS.BP I_EQUATE
    $INSERT GLOBUS.BP I_ENQUIRY.COMMON
    $INSERT JBL.BP I_F.ABL.H.NM.ER
    $INSERT JBL.BP I_F.ABL.H.BRANCH.CODE
    $INSERT GLOBUS.BP I_F.STMT.ENTRY
    $INSERT JBL.BP I_F.ABL.H.NM.ER


    FN.BR.CODE = "F.ABL.H.BRANCH.CODE"
    F.BR.CODE = ""
    FN.STMT = 'F.STMT.ENTRY'
    F.STMT = ''
    FN.NM = "F.ABL.H.NM.ER"
    F.NM = ""

    CALL OPF(FN.NM,F.NM)
    CALL OPF(FN.STMT,F.STMT)
    CALL OPF(FN.BR.CODE,F.BR.CODE)

    Y.STMT.ID = R.NEW(NM.REMARKS)

    CALL F.READ(FN.STMT,Y.STMT.ID,R.STMT,F.STMT,STMT.ERR)

    IF R.STMT EQ '' THEN

        AF = NM.REMARKS
        ETEXT = 'Invalid stmt Id'

        CALL STORE.END.ERROR

    END
    ELSE

        CALL F.READ(FN.NM,ID.NEW,R.NM,F.NM,Y.ERR)
        Y.NM.STMT.ID = R.NM<NM.RESERVED.1>

        IF Y.NM.STMT.ID NE '' AND Y.NM.STMT.ID NE Y.STMT.ID THEN
            AF = NM.REMARKS
            ETEXT = 'This record is belongs to ': Y.NM.STMT.ID

            CALL STORE.END.ERROR

        END ELSE

            Y.STMT.AMT = R.STMT<AC.STE.AMOUNT.LCY>

            IF Y.STMT.AMT LT 0 THEN
                DR.CR.MARK = 'DR'
            END ELSE
                DR.CR.MARK = 'CR'
            END

            R.NEW(NM.VALUE.DATE)  = R.STMT<AC.STE.PROCESSING.DATE>
            R.NEW(NM.AMOUNT)      = ABS(Y.STMT.AMT)
            R.NEW(NM.DR.CR.MARKER)= DR.CR.MARK
            R.NEW(NM.RESERVED.1) = Y.STMT.ID

            R.NEW(NM.BRANCH.CODE) = COMI

            CALL F.READ(FN.BR.CODE,COMI,R.BR.CODE,F.BR.CODE,Y.BR.ERR)
            R.NEW(NM.ZONAL.CODE) = R.BR.CODE<BRN.ZONAL.CODE>
        END
    END
    RETURN
END
