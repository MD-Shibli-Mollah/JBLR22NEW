    SUBROUTINE TTV.CK
    $INSERT GLOBUS.BP I_COMMON
    $INSERT GLOBUS.BP I_EQUATE
    $INSERT GLOBUS.BP I_System
    $INSERT BP I_F.TT.VAULT

    IF ID.NEW[1,4] NE ID.COMPANY[6,4] OR NUM(ID.NEW[6,8]) NE 1 OR LEN(ID.NEW) NE 13 THEN
        AF = 0
        ETEXT = 'Invalid ID Entered. Proper ID Formation is [4 Digit Branch Code].[Value Date]'
        CALL STORE.END.ERROR
        RETURN
    END
    IF ID.NEW[6,8] GT TODAY THEN
        AF = 0
        ETEXT = 'Invalid ID Entered. Value Date can not be greater than Today.'
        CALL STORE.END.ERROR
        RETURN
    END
    IF ID.COMPANY[1,5] NE 'BD001' AND ID.COMPANY EQ 'BD0015051' AND ID.COMPANY EQ 'BD0019999' THEN
        AF = 0
        ETEXT = 'This branch is not authorised for this operation.'
        CALL STORE.END.ERROR
        RETURN
    END
    FN.V = 'F.TT.VAULT'
    F.V = ''
    CALL OPF(FN.V,F.V)
    F.UNIT = 0
    F.AMT = 0
    M.UNIT = 0
    M.AMT = 0
    N.UNIT = 0
    N.AMT = 0
    COIN = 0
    C.AMT = 0
    T.CUR.UNIT = 0
    T.CUT.AMT = 0
    FOR I = 1 TO DCOUNT(R.NEW(TTV.DENOM),@VM)
        IF R.NEW(TTV.DENOM)<1,I> EQ '' THEN
            AF = 0
            ETEXT = 'Currency Can not be added.'
            CALL STORE.END.ERROR
            RETURN
        END
        Y.CUR = R.NEW(TTV.DENOM)<1,I>[4,LEN(R.NEW(TTV.DENOM)<1,I>)-3]
        IF (Y.CUR GT 5 AND R.NEW(TTV.COIN)<1,I> GT 0) OR COUNT(R.NEW(TTV.COIN)<1,I>,'.') GT 0 THEN
            AF = TTV.COIN
            AV = I
            ETEXT = 'Invalid Coin Information.'
            CALL STORE.END.ERROR
            RETURN
        END
        IF COUNT(R.NEW(TTV.M.UNIT)<1,I>,'.') GT 0 THEN
            AF = TTV.M.UNIT
            AV = I
            ETEXT = 'Invalid Mutilated Note Information.'
            CALL STORE.END.ERROR
            RETURN
        END
        IF COUNT(R.NEW(TTV.F.UNIT)<1,I>,'.') GT 0 THEN
            AF = TTV.F.UNIT
            AV = I
            ETEXT = 'Invalid Fresh Note Information.'
            CALL STORE.END.ERROR
            RETURN
        END
        IF COUNT(R.NEW(TTV.N.UNIT)<1,I>,'.') GT 0 THEN
            AF = TTV.N.UNIT
            AV = I
            ETEXT = 'Invalid Non-Issue Note Information.'
            CALL STORE.END.ERROR
            RETURN
        END


        IF Y.CUR LT 1 THEN
            IF R.NEW(TTV.M.UNIT)<1,I> GT 0 THEN
                AF = TTV.M.UNIT
                AV = I
                ETEXT = 'Coin should not be Mutilated Note.'
                CALL STORE.END.ERROR
                RETURN
            END
            IF R.NEW(TTV.F.UNIT)<1,I> GT 0 THEN
                AF = TTV.F.UNIT
                AV = I
                ETEXT = 'Coin should not be Fresh Note.'
                CALL STORE.END.ERROR
                RETURN
            END
            IF R.NEW(TTV.N.UNIT)<1,I> GT 0 THEN
                AF = TTV.N.UNIT
                AV = I
                ETEXT = 'Coin should not be Non Issue Note.'
                CALL STORE.END.ERROR
                RETURN
            END
        END
        IF R.NEW(TTV.F.UNIT)<1,I> EQ '' THEN R.NEW(TTV.F.UNIT)<1,I> = 0
        IF R.NEW(TTV.M.UNIT)<1,I> EQ '' THEN R.NEW(TTV.M.UNIT)<1,I> = 0
        IF R.NEW(TTV.N.UNIT)<1,I> EQ '' THEN R.NEW(TTV.N.UNIT)<1,I> = 0
        IF R.NEW(TTV.COIN)<1,I> EQ '' THEN R.NEW(TTV.COIN)<1,I> = 0
        F.UNIT = F.UNIT + R.NEW(TTV.F.UNIT)<1,I>
        F.AMT = F.AMT + R.NEW(TTV.F.UNIT)<1,I> * Y.CUR
        M.UNIT = M.UNIT + R.NEW(TTV.M.UNIT)<1,I>
        M.AMT = M.AMT + R.NEW(TTV.M.UNIT)<1,I> * Y.CUR
        N.UNIT = N.UNIT + R.NEW(TTV.N.UNIT)<1,I>
        N.AMT = N.AMT + R.NEW(TTV.N.UNIT)<1,I> * Y.CUR
        COIN = COIN + R.NEW(TTV.COIN)<1,I>
        C.AMT = C.AMT + R.NEW(TTV.COIN)<1,I> * Y.CUR
    NEXT I
    T.CUR.UNIT = T.CUR.UNIT + F.UNIT + M.UNIT + N.UNIT + COIN
    T.CUR.AMT = T.CUR.AMT + F.AMT + M.AMT + N.AMT + C.AMT
    IF COUNT(C.AMT,'.') EQ 1 AND LEN(FIELD(C.AMT,'.',2)) EQ 1 THEN C.AMT = C.AMT : '0'
    IF COUNT(T.CUR.AMT,'.') EQ 1 AND LEN(FIELD(T.CUR.AMT,'.',2)) EQ 1 THEN T.CUR.AMT = T.CUR.AMT : '0'
    LNGVAR = T.CUR.AMT
    TXTOUT = ''
    TXTVAR1=''
    INTVAL=''
    Y.COMI.LEN = LEN(T.CUR.AMT)
    IF Y.COMI.LEN LT 20 THEN
        INTVAL = FIELD(LNGVAR,'.',1)
        INTVAL3 = FIELD(LNGVAR,'.',2)

        IF INTVAL3 NE 0 THEN
            INTVAL2=INTVAL3
        END ELSE
            INTVAL2=0
        END

        CORE=INT(INTVAL / 10000000)
        CALL CALHUND(CORE,INTCORE)
        INTVAL = INT(INTVAL - INT(INTVAL / 10000000) * 10000000)

        LAC=INT(INTVAL / 100000)
        CALL CALHUND(LAC,INTLAC)
        INTVAL = INT(INTVAL - INT(INTVAL / 100000) * 100000)

        THOUSAND=INT(INTVAL / 1000)
        CALL CALHUND(THOUSAND,INTTHOUSAND)
        INTVAL = INT(INTVAL - INT(INTVAL / 1000) * 1000)

        HUNDRED=INT(INTVAL / 100)
        CALL CALHUND(HUNDRED,INTHUNDRED)
        INTVAL = INT(INTVAL - INT(INTVAL / 100) * 100)

        REST=INT(INTVAL / 1)
        CALL CALHUND(REST,INTREST)

!DES=INT(INTVAL2 / 1)
        DES = FIELD(DROUND(LNGVAR),'.',2)
        IF LEN(DES) EQ '1' THEN DES = DES * 10
        CALL CALHUND(DES,INTDES)

        IF LEN(INTCORE) EQ 0 THEN
            TXTVAR1=INTCORE:"":""
        END ELSE
            TXTVAR1=INTCORE:" ":"Crore"
        END

        IF LEN(INTLAC) EQ 0 THEN
            TXTVAR1=TXTVAR1:"":INTLAC:"":""
        END ELSE
            TXTVAR1=TXTVAR1:" ":INTLAC:" ":"Lac"
        END

        IF LEN(INTTHOUSAND) EQ 0 THEN
            TXTVAR1=TXTVAR1:"":INTTHOUSAND:"":""
        END ELSE
            TXTVAR1=TXTVAR1:" ":INTTHOUSAND:" ":"Thousand"
        END

        IF LEN(INTHUNDRED) EQ 0 THEN
            TXTVAR1=TXTVAR1:"":INTHUNDRED:"":""
        END ELSE
            TXTVAR1=TXTVAR1:" ":INTHUNDRED:" ":"Hundred"
        END

        TXTVAR1="Taka ":TXTVAR1:" ":INTREST
        IF LEN(INTDES) EQ 0 THEN
            TXTVAR1=TXTVAR1:""
        END
        ELSE
            TXTVAR1=TXTVAR1:" ":"and":" Paisa ":INTDES
        END
        TXTOUT = EREPLACE (TXTVAR1,"  "," ")

        IF T.CUR.AMT EQ 0 THEN
            AF = TTV.T.AMT
            ETEXT = 'Total Amount should not be null.'
            CALL STORE.END.ERROR
            RETURN
        END
        ELSE
            R.NEW(TTV.T.F.UNIT) = F.UNIT
            R.NEW(TTV.T.F.AMT) = F.AMT
            R.NEW(TTV.T.M.UNIT) = M.UNIT
            R.NEW(TTV.T.M.AMT) = M.AMT
            R.NEW(TTV.T.N.UNIT) = N.UNIT
            R.NEW(TTV.T.N.AMT) = N.AMT
            R.NEW(TTV.T.COIN) = COIN
            R.NEW(TTV.T.C.AMT) = C.AMT
            R.NEW(TTV.T.UNIT) = T.CUR.UNIT
            R.NEW(TTV.T.AMT) = T.CUR.AMT
            R.NEW(TTV.T.AMT.W) = TXTOUT
        END
        RETURN
    END
